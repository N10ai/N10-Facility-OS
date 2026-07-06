import { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { supabase, isSupabaseConfigured } from '../../services/supabaseClient';
const AuthContext = createContext(null);
export function AuthProvider({children}){
 const [session,setSession]=useState(null); const [profile,setProfile]=useState(null); const [loading,setLoading]=useState(true);
 async function loadProfile(userId){
  if(!supabase||!userId){setProfile(null);return}
  const {data,error}=await supabase.from('profiles').select('*, companies(name, brand_color)').eq('id',userId).maybeSingle();
  if(!error) setProfile(data||null);
 }
 useEffect(()=>{ if(!supabase){setLoading(false);return}
  supabase.auth.getSession().then(async ({data})=>{setSession(data.session||null); if(data.session?.user?.id) await loadProfile(data.session.user.id); setLoading(false);});
  const {data:listener}=supabase.auth.onAuthStateChange(async (_e,next)=>{setSession(next); if(next?.user?.id) await loadProfile(next.user.id); else setProfile(null);});
  return ()=>listener.subscription.unsubscribe();
 },[]);
 async function signIn(email,password){ if(!supabase) return {error:{message:'Supabase not configured'}}; return supabase.auth.signInWithPassword({email,password});}
 async function signUp(email,password){ if(!supabase) return {error:{message:'Supabase not configured'}}; return supabase.auth.signUp({email,password});}
 async function signOut(){ if(supabase) await supabase.auth.signOut();}
 async function upsertMyProfile(fullName,role='owner'){
  if(!supabase||!session?.user?.id) return {error:{message:'Login first'}};
  const {error}=await supabase.from('profiles').upsert({id:session.user.id,full_name:fullName||session.user.email,role});
  if(!error) await loadProfile(session.user.id); return {error};
 }
 const value=useMemo(()=>({session,profile,loading,isSupabaseConfigured,signIn,signUp,signOut,upsertMyProfile,reloadProfile:()=>loadProfile(session?.user?.id)}),[session,profile,loading]);
 return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
export function useAuth(){return useContext(AuthContext)}
