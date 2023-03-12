import legacy from '@vitejs/plugin-legacy'
import {defineConfig, splitVendorChunkPlugin} from 'vite'
import liveReload from 'vite-plugin-live-reload'
import path from 'path'

export default defineConfig({
  // CONFIG
  root: '',
  base: '/',
  manifest: true,
  build: {
    assetsDir: "./",
    outDir: './public/dist',
    emptyOutDir: true,
    reportCompressedSize: true,
    copyPublicDir: false,
    manifest: true,
    minify: true,
    rollupOptions: {
      input: [
        path.resolve(__dirname, 'assets/ts/app.ts'),
        path.resolve(__dirname, 'assets/sass/app.sass'),
      ],
    }
  },
  server: {
    strictPort: true,
    port: 3000,
    cors: true,
  },

  // PLUGINS
  plugins: [
    legacy({
      targets: ['defaults', 'not IE 11'],
    }),
    liveReload([
      'assets/ts/**/*.ts',
      'assets/sass/**/*.sass',
      'public/index.php',
    ]),
    splitVendorChunkPlugin(),
  ],
})
