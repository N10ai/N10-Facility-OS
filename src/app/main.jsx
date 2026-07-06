import React from 'react';
import { createRoot } from 'react-dom/client';
import { AuthProvider } from '../core/auth/AuthProvider';
import { App } from './App';
import '../styles/app.css';
createRoot(document.getElementById('root')).render(<React.StrictMode><AuthProvider><App /></AuthProvider></React.StrictMode>);
