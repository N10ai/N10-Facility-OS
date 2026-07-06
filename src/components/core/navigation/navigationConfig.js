import { LayoutDashboard, Building2, UsersRound, BriefcaseBusiness, CalendarDays, Camera, ReceiptText, Settings, ShieldCheck, Search, Bell, Wrench, DollarSign } from 'lucide-react';
export const portals = [
  { key:'owner', label:'Owner/Admin', short:'Owner' },
  { key:'manager', label:'Manager', short:'Mgr' },
  { key:'employee', label:'Employee', short:'Work' },
  { key:'customer', label:'Customer', short:'Client' },
  { key:'sales', label:'Sales', short:'Sales' }
];
export const navSections = [
 { title:'Command', items:[
  { key:'mission-control', label:'Mission Control', icon:LayoutDashboard, portals:['owner','manager','employee','customer','sales'] },
  { key:'global-search', label:'Global Search', icon:Search, portals:['owner','manager','sales'] },
  { key:'notifications', label:'Notifications', icon:Bell, portals:['owner','manager','employee','customer','sales'] }
 ]},
 { title:'Core', items:[
  { key:'company', label:'Company Setup', icon:Building2, portals:['owner'] },
  { key:'workspace-members', label:'Workspace Members', icon:UsersRound, portals:['owner','manager'] },
  { key:'customers', label:'Customers', icon:BriefcaseBusiness, portals:['owner','manager','sales'] },
  { key:'facilities', label:'Facilities', icon:Building2, portals:['owner','manager','employee','customer'] }
 ]},
 { title:'Engines', items:[
  { key:'service-visits', label:'Service Visits', icon:CalendarDays, portals:['owner','manager','employee','customer'] },
  { key:'verification', label:'Verification Engine', icon:Camera, portals:['owner','manager','employee','customer'] },
  { key:'issues', label:'Issues', icon:Wrench, portals:['owner','manager','employee','customer'] },
  { key:'quotes', label:'Quotes', icon:DollarSign, portals:['owner','manager','customer','sales'] },
  { key:'invoices', label:'Invoices', icon:ReceiptText, portals:['owner','customer'] }
 ]},
 { title:'System', items:[
  { key:'permissions', label:'Roles & Permissions', icon:ShieldCheck, portals:['owner'] },
  { key:'settings', label:'Settings', icon:Settings, portals:['owner','manager','employee','customer','sales'] }
 ]}
];
export function getVisibleNav(portal){ return navSections.map(s=>({...s,items:s.items.filter(i=>i.portals.includes(portal))})).filter(s=>s.items.length); }
