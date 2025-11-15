# Deploy Backend to Vercel

## Steps:

1. **Install Vercel CLI** (if not already installed):
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**:
   ```bash
   vercel login
   ```

3. **Deploy from Backend directory**:
   ```bash
   cd /home/arpit-raj-choudhary/sihack-beta/sih_bhu_jalan_app/Backend
   vercel
   ```

4. **Set Environment Variables** in Vercel dashboard:
   - `SUPABASE_URL`: Your Supabase project URL
   - `SUPABASE_KEY`: Your Supabase anon/service key

5. **Update Flutter app** with new Vercel URL:
   - Edit `Frontend/lib/services/api_services.dart`
   - Replace the baseUrl with your new Vercel deployment URL

## Example Vercel URL format:
`https://your-project-name.vercel.app`
