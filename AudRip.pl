#!/usr/bin/env perl

print <<EOTEXT;
   _____            .___         __________.__        
  /  _  \  __ __  __| _/         \______   \__|_____  
 /  /_\  \|  |  \/ __ |   ______  |       _/  \____ \ 
/    |    \  |  / /_/ |  /_____/  |    |   \  |  |_> >
\____|__  /____/\____ |           |____|_  /__|   __/ 
        \/           \/                  \/   |__|    

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
also creates a lockfile in /tmp \n\n
EOTEXT

if ($ARGV[0] eq "--forcestart") {
	`rm -f /tmp/aud-rip.lock`;
} 

unless (-e "/tmp/aud-rip.lock") {
	open (FILE, ">/tmp/aud-rip.lock"); 
	print FILE "Aud-Rip is running!"; 
	close (FILE); 
} else {
	die("Aud-Rip is currently running..\nIf you find this not the case use --forcestart\n$!");
}
print "\nStarting up...\n";
use Proc::Daemon;
Proc::Daemon::Init;
my $BGPROC = 1;
$SIG{TERM} = sub { $BGPROC = 0 };
while ($BGPROC) {
use MIME::Base64;
use Gtk2::TrayIcon;
Gtk2->init;
my $icon_data2 = "
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAyUlEQVRIx+3TMQ6CQBBA0b+EhKwa
LuEJvIAnsfYMdNzDS4ix8EYECI2JCZCYHQu1EMFmh0adZjPNvp3ZGZg4DMAW1g6OWpcGUO9gCRAC
ODhtjJlZa0HE+8VZ08TPPHycVxtFrNIUcc4PMIZ9ktAHEBGaPPcHguDe9z6Ac3RV5Q/08pcK2qJQ
+YNBABHaqlIBBlskztGVpc7cj1XQ1bU6EEy9yX/gB4BQWxvdAwPMpwQArBIgnyqQKVu0UALeKjBw
OUCcKU3OmW+KGw7KQzmoMWWeAAAAAElFTkSuQmCC
";
my $icon_data = "
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";

unless (-e "/tmp/record.png") {
	open FILE, ">/tmp/record.png" or die "NO ICON!!! READ THE DOC!";
	print FILE decode_base64($icon_data); 
	close FILE;
} 

unless (-e "/tmp/stop-record.png") {
	open FILE, ">/tmp/stop-record.png" or die "NO ICON!!! READ THE DOC!";
	print FILE decode_base64($icon_data2); 
	close FILE;
} 

my $icon= Gtk2::TrayIcon->new("Ripper");
my $action = Gtk2::EventBox->new;
my $img= Gtk2::Image->new_from_file("/tmp/record.png");
$action->add($img);
$icon->signal_connect('button-press-event' => sub{ &memenu });
$icon->add($action);
$icon->show_all;
Gtk2->main;

sub memenu {
	$app_menu = Gtk2::ItemFactory->new("Gtk2::Menu", '<main>', undef);
	$item_menu = $app_menu->get_widget('<main>');
	@menu_list = ( { path => '/GetIt', item_type => '<Item>', callback => \&getit},
			{ path => '/StopIt', item_type => '<Item>', callback => \&stopit},
			{ path => '/-----', item_type => '<Item>', callback => \&null},
			{ path => '/About', item_type => '<Item>', callback => \&bout},
			{ path => '/Exit', item_type => '<Item>', callback => \&quitit } );
	$app_menu->create_items(undef, @menu_list);
	$item_menu->show_all;
	$item_menu->popup(undef, undef, undef, undef, 0, 0);
}

sub quitit {
	`rm -f /tmp/aud-rip.lock`;
	Gtk2->main_quit;
	$QUIT = $BGPROC->Kill_Daemon();
}

sub getit {
	$img->clear;
	$action->remove($img);
	$img= Gtk2::Image->new_from_file("/tmp/stop-record.png");
	$action->add($img);
	$icon->show_all;
	$ft = "ripped_" . int(rand(1000)) . ".mp3";
 	$launchit = "arecord -r44100 -c2 | lame --tc 'Play Ripped Via Audrip!' -h - ~/$ft";
	my $new_proc = fork();
	if (defined $new_proc && $new_proc == 0) {
		system($launchit);
	exit 0;
 }
}

sub stopit {
	$img->clear;
	$action->remove($img);
	$img= Gtk2::Image->new_from_file("/tmp/record.png");
	$action->add($img);
	$icon->show_all;
	$killit = `pidof arecord`;
	`kill -9 $killit`;
	savedas();
}

sub bout {
	$bout = Gtk2::AboutDialog->new;
	$bout->set_program_name("Aud-Rip");
	$bout->set_version($VERSION);
	$bout->set_copyright("Scripted by: BitBytes");
	$bout->set_comments("Pipes arecord thru lame to create an mp3 from the currently playing audio on your machine");
	$bout->set_website("bitbytes\@gmx.us");
	$bout->run;
	$bout->destroy;
}

sub savedas {
$info_window = Gtk2::MessageDialog->new ($main_application_window, 'destroy-with-parent', 'info', 'ok', "File saved as $ft");
$inforesponse = $info_window->run;
  if ($inforesponse eq 'ok') {
      $info_window->destroy;
  }
}

sub null{}
}


