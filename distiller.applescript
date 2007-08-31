-- Part of the build-system for managing my doctoral dissertation.
-- (c) Harish Narayanan, 2007

on run argv
	tell application "Finder" to get folder of (path to me) as Unicode text
	set workingPath to POSIX path of result
	set inFile to workingPath & item 1 of argv
	
	tell application "Acrobat Distiller"
		Distill sourcePath inFile destinationPath workingPath adobePDFSettingsPath "/Library/Application Support/Adobe/Adobe PDF/Settings/High Quality Print.joboptions"
		run
		quit
	end tell
	
end run