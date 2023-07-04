//==============================================
//  Second Viennese School v1.0
//  https://github.com/XiaoMigros/Second-Viennese-School
//  Copyright (C)2023 XiaoMigros
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//==============================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	version: "1.0"
	menuPath: "Accidentals.Second Viennese School.Add Accidentals"
	description: "This plugin adds accidentals to the score, following the rules of the Second Viennese School."
	requiresScore: true
	
	Component.onCompleted: {
		if (mscoreMajorVersion >= 4) {
			title = "Add Second Viennese School Accidentals"
			categoryCode = "composing-arranging-tools"
			thumbnailName = "logo.png"
		}
	}
	function tpcToName(tpc) {
		var tpcNames = [ //-1 thru 33
			"Fbb", "Cbb", "Gbb", "Dbb", "Abb", "Ebb", "Bbb",
			"Fb",  "Cb",  "Gb",  "Db",  "Ab",  "Eb",  "Bb",
			"F",   "C",   "G",   "D",   "A",   "E",   "B",
			"F#",  "C#",  "G#",  "D#",  "A#",  "E#",  "B#",
			"F##", "C##", "G##", "D##", "A##", "E##", "B##"
		]
		return tpcNames[tpc+1]
	}
	onRun: {
		curScore.startCmd()
		if (!curScore.selection.elements.length) {
			console.log("No selection. Applying plugin to all notes...")
			cmd("select-all")
		} else {
			console.log("Applying plugin to selection...")
		}
		for (var i in curScore.selection.elements) {
			if (curScore.selection.elements[i].type == Element.NOTE && ! curScore.selection.elements[i].staff.part.hasDrumStaff) {
				restateAccidental(curScore.selection.elements[i])
			}
		}
		curScore.endCmd()
		smartQuit()
	}
	function restateAccidental(note) {		
		var oldAccidental = note.accidentalType
		var accidental = Accidental.NONE
		switch (true) {
			case (note.tpc > 26): {
				accidental = Accidental.SHARP2
				break
			}
			case (note.tpc > 19): {
					accidental = Accidental.SHARP
				break
			}
			case (note.tpc > 12): {
				accidental = Accidental.NATURAL
				break
			}
			case (note.tpc > 5): {
				accidental = Accidental.FLAT
				break
			}
			default: {
				accidental = Accidental.FLAT2
			}
		}
		if (accidental != oldAccidental) {
			note.accidentalType = accidental
			note.accidental.visible = note.visible
			console.log("Added a cautionary accidental to note " + tpcToName(note.tpc))
		}
	}
	function smartQuit() {
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
}
