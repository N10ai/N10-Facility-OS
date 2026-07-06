import { useState } from 'react';
import { Menu, X, Search, Bell, HelpCircle, ChevronDown, Plus } from 'lucide-react';
import { AuthModal } from '../../core/auth/AuthModal';
import { useAuth } from '../../core/auth/AuthProvider';
import { getVisibleNav, portals } from '../../core/navigation/navigationConfig';
export function AppShell({activePage,setActivePage,portal,setPortal,children}){
 const {session,profile}=useAuth(); const [drawerOpen,setDrawerOpen]=useState(false),[authOpen,setAuthOpen]=useState(false);
 const nav=getVisibleNav(portal); const bottomItems=nav.flatMap(s=>s.items).slice(0,5); const userLabel=profile?.full_name||session?.user?.email||'Sign in';
 function navigate(key){setActivePage(key);setDrawerOpen(false)}
 const SidebarContent=<><button className="brandButton" onClick={()=>setAuthOpen(true)}><div className="brandMark">AI</div><div><strong>FacilityOS</strong><span>Core Epic 001</span></div></button>
 <div className="portalPicker">{portals.map(p=><button key={p.key} className={portal===p.key?'active':''} onClick={()=>setPortal(p.key)}>{p.short}</button>)}</div>
 {nav.map(section=><div key={section.title}><div className="navSection">{section.title}</div><nav className="sideNav">{section.items.map(item=>{const Icon=item.icon;return <button key={item.key} className={activePage===item.key?'navItem active':'navItem'} onClick={()=>navigate(item.key)}><Icon size={18}/><span>{item.label}</span></button>})}</nav></div>)}
 <div className="sidebarFooter"><span className={session?'statusDot ok':'statusDot'}/><span>{session?`Logged in as ${userLabel}`:'Click logo to sign in'}</span></div></>;
 return <><header className="mobileTopbar"><button className="iconButton" onClick={()=>setDrawerOpen(true)}><Menu/></button><button className="mobileLogo" onClick={()=>setAuthOpen(true)}>FacilityOS</button><button className="iconButton" onClick={()=>setAuthOpen(true)}><ChevronDown/></button></header>
 <div className="appShell"><aside className="desktopSidebar">{SidebarContent}</aside>{drawerOpen&&<div className="drawerOverlay" onClick={()=>setDrawerOpen(false)}/>}<aside className={drawerOpen?'mobileDrawer open':'mobileDrawer'}><button className="drawerClose" onClick={()=>setDrawerOpen(false)}><X/></button>{SidebarContent}</aside>
 <main className="mainShell"><div className="topbar"><div className="searchPill"><Search size={17}/><span>Search customers, facilities, visits, invoices...</span></div><div className="topbarActions"><button className="iconText"><Plus size={17}/> Quick Add</button><button className="iconButton"><Bell size={18}/></button><button className="iconButton"><HelpCircle size={18}/></button><button className="accountButton" onClick={()=>setAuthOpen(true)}><span>{userLabel}</span><small>{profile?.role||(session?'Profile needed':'Not logged in')}</small></button></div></div>{children}</main></div>
 <nav className="bottomNav">{bottomItems.map(item=>{const Icon=item.icon;return <button key={item.key} className={activePage===item.key?'bottomItem active':'bottomItem'} onClick={()=>navigate(item.key)}><Icon size={18}/><span>{item.label.split(' ')[0]}</span></button>})}</nav><AuthModal open={authOpen} onClose={()=>setAuthOpen(false)}/></>
}
