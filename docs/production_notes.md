# Production Notes

## Project Rule

No direct system file overwrites.

Everything should be built as a reversible Magisk module.

## Current Pipeline

1. Build frames locally.
2. Package bootanimation.zip.
3. Copy into Magisk module path.
4. Zip module.
5. Install with Magisk CLI.

## Safety Scripts To Include

- enable module script
- disable module script
- install module script
- verify module script
- post-reboot healthcheck script

## Future Improvements

- animated cigar ember
- head-specific personality motion
- ring pulse
- boot progress text
- optional NotEvil variant
- optional Endgame-only variant
