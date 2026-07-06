import { useState } from 'react';
import { X } from 'lucide-react';
import { useAuth } from './AuthProvider';
export function AuthModal({open,onClose}){
 const {session,profile,signIn,signUp,signOut,upsertMyProfile}=useAuth();
 const [mode,setMode]=useState('login'),[email,setEmail]=useState(''),[password,setPassword]=useState(''),[fullName,setFullName]=useState(''),[message,setMessage]=useState('');
 if(!open) return null;
 async function submit(){ const {error}= mode==='login' ? await signIn(email,password) : await signUp(email,password); setMessage(error?error.message:(mode==='login'?'Logged in.':'Account created. Confirm email if required.')); }
 async function saveProfile(){ const {error}=await upsertMyProfile(fullName||session?.user?.email,'owner'); setMessage(error?error.message:'Profile saved.'); }
 return <div className="modalOverlay"><section className="authModal"><button className="modalClose" onClick={onClose}><X size={18}/></button>
  <div className="authHero"><div className="brandMark large">AI</div><h2>FacilityOS Access</h2><p>Secure workspace entry for owners, managers, employees, customers, vendors, and sales teams.</p></div>
  {!session ? <>
   <div className="segmented"><button className={mode==='login'?'active':''} onClick={()=>setMode('login')}>Login</button><button className={mode==='signup'?'active':''} onClick={()=>setMode('signup')}>Create Account</button></div>
   <div className="form"><label>Email<input value={email} onChange={e=>setEmail(e.target.value)}/></label><label>Password<input type="password" value={password} onChange={e=>setPassword(e.target.value)}/></label><button className="btn primary" onClick={submit}>{mode==='login'?'Login':'Create Account'}</button></div>
  </> : <div className="accountPanel"><p className="eyebrow">Logged in as</p><h3>{profile?.full_name||session.user.email}</h3><p>{session.user.email}</p><div className="accountMeta"><span>Role: {profile?.role||'Profile not created'}</span><span>Company: {profile?.companies?.name||'Not linked yet'}</span></div><div className="form compact"><label>Display Name<input value={fullName} onChange={e=>setFullName(e.target.value)} placeholder={profile?.full_name||session.user.email}/></label><button className="btn primary" onClick={saveProfile}>Create/Update Owner Profile</button><button className="btn ghost" onClick={signOut}>Logout</button></div></div>}
  {message&&<div className="notice">{message}</div>}
 </section></div>
}
