# Task: Save the Vercel Ship 2026 keynote transcript

**Dependencies**: Outside trigger: YouTube captions on the stream, or Vercel's
per-session uploads. Check back around 2026-10-20, then 2026-10-23.

## Why This Matters
`docs/vercel-ship-2026/notes.md` comes from watching the stream live. A
transcript lets agents in this repo ground answers in what was actually said,
not a summary of it. On 2026-10-16 the stream (`Fr5vzNknYJE`, 6:31:22) had no
captions of any kind, so `/media-tools:youtube-transcript` could not run.

## Success Criteria
- [ ] Transcript covering 0:00 to 1:40:00 of the stream (or the per-session
      videos for that span) saved under `docs/vercel-ship-2026/transcripts/`
- [ ] `docs/vercel-ship-2026/transcripts/AGENTS.md` carries the verbatim
      Untrusted Content Block (copy from `docs/vercel-official/AGENTS.md`),
      plus a one-line `CLAUDE.md` containing `@AGENTS.md`
- [ ] `notes.md` links each saved transcript

## Approach
1. Check Vercel's YouTube channel for per-session uploads first; transcribe
   those with `/media-tools:youtube-transcript -o docs/vercel-ship-2026/transcripts <id>`
   (the script reads flags only before the video IDs).
2. Else retry `/media-tools:youtube-transcript Fr5vzNknYJE`. YouTube serves the
   whole caption track, so trim the JSON to entries with `start < 6000`. The
   rest of the stream is mostly music breaks.
3. Last resort: download only that audio section with
   `yt-dlp --download-sections "*0:00-1:40:00" -x` (ffmpeg is installed) and
   transcribe it with `media-tools:transcribe-audio`. Plain text, no
   timestamps.

## Out of Scope
- The stream after 1:40:00 (mostly music breaks)
