
Dependencies: 
Perl / Gtk2::TrayIcon / MIME::Base64 / Proc::Daemon / arecord / lame

cpan install Gtk2::TrayIcon
cpan install MIME::Base64 
cpan install Proc::Daemon 
#############################################################################
Check your distros repositories for (arecord and lame) 
#############################################################################
System tray script that pipes arecord thru lame and saves as a mp3 file
as ripped_#RANDOM#.mp3 what it does not do is check if file exists and it 
does not set up your mixer settings to be able to record with arecord 
This script creates 2 icons in /tmp directory for use make sure you have
write permission or edit the script manually and change the paths 
also creates a lockfile in /tmp
