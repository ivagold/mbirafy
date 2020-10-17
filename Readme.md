# Mbirafy: *Turn your MIDIs into Mbira/Kalimba tabs!*

This is a plugin for [MuseScore 3](https://musescore.org). It's a fork of the [notenames plugin](https://github.com/Jojo-Schmitz/notenames), but instead of labelling notes with English note names (A, B, C, ...), it labes them with numbers that correspond to to mbira lammellae (keys/tines). I'm using it to apply Berliner notation to my music, but it can be used for any notation you prefer.

It adds labels to all notes in either the current selection or all voices of all staves in the entire score as staff text (above/below the staff).

This is a WORK IN PROGRESS. More to come soon.

**How I make mbira tabs from recordings:**
I start by creating a MIDI of the song using [AnthemScore](https://lunaverus.com). Then, I import the MIDI into MuseScore, and use this plugin to generate the numeric tablature. From there, I like to use that to build tabs in [Sympathetic Resonances](https://sympathetic-resonances.org).

### Installation:
To use the plugin, you must first install it according to the [instructions in the Handbook](http://musescore.org/en/handbook/plugins "Handbook").

### Usage notes:
If you want a separator different from ",", change the corresponding variable in the plugin code. You can also change it to "\n" to get the note names stacked vertically, but in that case most probably also need to modify the position it gets printed.

## Thanks:
Many thanks to the original creators & contributors of the [notenames plugin](https://github.com/Jojo-Schmitz/notenames). I started this code by forking that plugin; they did the hard work that makes it easy to every note with a text value. Very helpful!

I got the idea for this plugin after reading Jojo-Schmitz's [comments on this post](https://musescore.org/en/node/267863). He pointed out that the notenames plugin could be modified to do exactly what I want.