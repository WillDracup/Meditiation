# Singing Bowl — meditation timer

A small web app that installs onto your phone like a normal app and works offline.
Three stages (Settle in -> Meditation -> Return), adjustable times, four bowl sounds,
and an adjustable number of strikes at the end of each stage. All settings are saved
on the device. The bowl sounds are generated in the app, so there are no audio files
to go missing.

## What's in this folder
- index.html .............. the app
- manifest.webmanifest .... lets it install as a standalone app
- sw.js ................... makes it work offline
- icon-192.png / icon-512.png / icon-maskable-512.png / apple-touch-icon.png .. app icons
- make_icons.py ........... the script that drew the icons (not needed to run the app)

## Put it on your phone (pick ONE host)

You need these files on an HTTPS web address, then "Add to Home Screen". Two easy ways:

### A. Netlify Drop — fastest, no setup
1. On a computer, go to:  https://app.netlify.com/drop
2. Drag this whole folder onto the page (sign in with email/Google if asked — free).
3. It gives you a link like  https://something.netlify.app
4. Open that link on your phone (see "Add to Home Screen" below).

### B. GitHub Pages — permanent, free
1. Create a new repository at github.com (e.g. "bowl"), Public.
2. Upload every file in this folder (drag them into the repo).
3. Repo -> Settings -> Pages -> "Deploy from a branch" -> branch "main", folder "/ (root)" -> Save.
4. Wait ~1 minute, then open the link it shows on your phone.

### Add to Home Screen
- iPhone (Safari): Share button -> "Add to Home Screen" -> Add.
- Android (Chrome): menu (3 dots) -> "Install app" / "Add to Home Screen".

After that it opens full-screen with its own icon, and works with no signal.

## Resume notes
- Defaults: Settle 1:00, Meditation 15:00, Return 1:00; bowl = Tibetan;
  strikes = 1 / 3 / 1. Change anything via the "Adjust" button.
- To change the bowl sounds themselves, edit the PRESETS block near the top of the
  <script> in index.html (frequency, partials, decay).
- If you update the app later, change CACHE = "bowl-v1" to "bowl-v2" in sw.js so phones
  pick up the new version.
