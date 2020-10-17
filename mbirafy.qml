//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Mbirafy - a fork of the Note Names Plugin
//  https://github.com/ivagold/mbirafy
//
//  Copyright (C) 2012 Werner Schweer
//  Copyright (C) 2013 - 2019 Joachim Schmitz
//  Copyright (C) 2014 Jörn Eichler
//  Copyright (C) 2020 Iva Goldsmith
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
   version: "3.0"
   description: qsTr("This plugin labels notes with mbira tablature.")
   menuPath: "Plugins.Notes." + qsTr("Mbirafy") // Does this work?

   function nameChord (notes, text) {
      for (var i = 0; i < notes.length; i++) {
         //var sep = "," // change to "\n" if you want them vertically
         var sep = "\n";

         if ( i > 0 )
            text.text = sep + text.text; // any but top note

         if (typeof notes[i].pitch === "undefined") // like for grace notes ?!?
            return

         // To determine what pitch values to use, refer to this chart:
         // https://musescore.github.io/MuseScore_PluginAPI_Docs/plugins/html/pitch.html

         switch (notes[i].pitch) {
            // Notations for Chiwoniso's mbira in the Key of Gb (aka F#)
            case 78: text.text = qsTr("1'") + text.text; break; //G♭
            case 77: text.text = qsTr("4'") + text.text; break; //F
            case 75: text.text = qsTr("3'") + text.text; break; //E♭
            case 73: text.text = qsTr("2'") + text.text; break; //D♭
            case 70: text.text = qsTr("L4") + text.text; break; //B♭
            case 68: text.text = qsTr("L3") + text.text; break; //A♭
            case 66: text.text = qsTr("L2") + text.text; break; //G♭
            case 65: text.text = qsTr("R4") + text.text; break; //F
            case 63: text.text = qsTr("R3") + text.text; break; //E♭
            case 61: text.text = qsTr("R2") + text.text; break; //D♭
            case 58: text.text = qsTr("L1") + text.text; break; //B♭
            case 54: text.text = qsTr("R1") + text.text; break; //G♭

            default: text.text = qsTr("?") + text.text; break;

            // Alternatively, you can label each note with its pitch value:
            //default: text.text = qsTr("" + notes[i].pitch) + text.text; break;
         } // end switch tpc

      } // end for note
   } // end nameChord

   onRun: {
      if (typeof curScore === 'undefined')
         Qt.quit();

      var cursor = curScore.newCursor();
      var startStaff;
      var endStaff;
      var endTick;
      var fullScore = false;
      cursor.rewind(1);
      if (!cursor.segment) { // no selection
         fullScore = true;
         startStaff = 0; // start with 1st staff
         endStaff  = curScore.nstaves - 1; // and end with last
      } else {
         startStaff = cursor.staffIdx;
         cursor.rewind(2);
         if (cursor.tick === 0) {
            // this happens when the selection includes
            // the last measure of the score.
            // rewind(2) goes behind the last segment (where
            // there's none) and sets tick=0
            endTick = curScore.lastSegment.tick + 1;
         } else {
            endTick = cursor.tick;
         }
         endStaff = cursor.staffIdx;
      }
      console.log(startStaff + " - " + endStaff + " - " + endTick)

      for (var staff = startStaff; staff <= endStaff; staff++) {
         for (var voice = 0; voice < 4; voice++) {
            cursor.rewind(1); // beginning of selection
            cursor.voice    = voice;
            cursor.staffIdx = staff;

            if (fullScore)  // no selection
               cursor.rewind(0); // beginning of score

            while (cursor.segment && (fullScore || cursor.tick < endTick)) {
               if (cursor.element && cursor.element.type === Element.CHORD) {
                  var text = newElement(Element.STAFF_TEXT);

                  var graceChords = cursor.element.graceNotes;
                  for (var i = 0; i < graceChords.length; i++) {
                     // iterate through all grace chords
                     var graceNotes = graceChords[i].notes;
                     nameChord(graceNotes, text);
                     // there seems to be no way of knowing the exact horizontal pos.
                     // of a grace note, so we have to guess:
                     text.offsetX = -2.5 * (graceChords.length - i);
                     switch (voice) {
                        case 0: text.offsetY =  1; break;
                        case 1: text.offsetY = 10; break;
                        case 2: text.offsetY = -1; break;
                        case 3: text.offsetY = 12; break;
                     }

                     cursor.add(text);
                     // new text for next element
                     text = newElement(Element.STAFF_TEXT);
                  }

                  var notes = cursor.element.notes;
                  nameChord(notes, text);

                  switch (voice) {
                     case 0: text.offsetY =  1; break;
                     case 1: text.offsetY = 10; break;
                     case 2: text.offsetY = -1; break;
                     case 3: text.offsetY = 12; break;
                  }
                  if ((voice == 0) && (notes[0].pitch > 83))
                     text.offsetX = 1;
                  cursor.add(text);
               } // end if CHORD
               cursor.next();
            } // end while segment
         } // end for voice
      } // end for staff
      Qt.quit();
   } // end onRun
}
