# Backend Deployment Guide

## Deploy to Vercel via GitHub

### 1. Push to GitHub
```bash
git add .
git commit -m "Add Vercel configuration"
git push origin main
```

### 2. Deploy on Vercel
1. Go to [vercel.com](https://vercel.com)
2. Click "New Project"
3. Import your GitHub repository
4. Select the `Backend` folder as root directory
5. Vercel will auto-detect the Python project

### 3. Set Environment Variables
In Vercel dashboard → Settings → Environment Variables:
- `SUPABASE_URL`: `https://rxfbbhlwotcqncmnnqzn.supabase.co`
- `SUPABASE_KEY`: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4ZmJiaGx3b3RjcW5jbW5ucXpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg0NjQyNzcsImV4cCI6MjA3NDA0MDI3N30.4xgCDnSEz_MtX15_9ftYHqGtfUsmxUc7c2vO5L2om6A`

### 4. Update Flutter App
After deployment, update `Frontend/lib/services/api_services.dart`:
```dart
static const String baseUrl = "https://your-vercel-app.vercel.app";
```

### 5. Test Endpoints
- Health: `https://your-vercel-app.vercel.app/`
- Districts: `https://your-vercel-app.vercel.app/districts`
- Blocks: `https://your-vercel-app.vercel.app/blocks?district=Badaun`
