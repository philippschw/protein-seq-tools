#!/usr/bin/perl -w
# Instructions: 
# How to Use: perl getarea.pl PATH/TO_DIRECTORY_WITH_PDBSs
# Results will be written in same directory
# Please feel to modify it based on your requirement.
# Written by Surendra Negi, UTMB Galveston. 
#
use strict;
use LWP;
use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Headers;
my $ua = LWP::UserAgent->new();
my $request = HTTP::Request->new();
my $CURRENT_DIR=$ENV{'PWD'};
# my $PDBfile = shift;
my $url="http://curie.utmb.edu/cgi-bin/getarea.cgi";
my $name="test" ; # Use any name of choice.. default is test 
my $email = "ssnegi\@utmb.edu";# Please type your email address. e.g myemailID\@MyInstitute.edu
my $probesize = "1.4"; # Water probe
my $gradi= "n";  # (y OR n) if you are interested in gradient calculation
my $output = "2"; # 1= Total Area/Energy, 2 = Area per residue, 3 = Area per atom type, 4 = Area per individual atom type.
my $dir = shift;
opendir DIR,$dir;
my @dir = readdir(DIR);
close DIR;
foreach(@dir){
    if (-f $dir . "/" . $_ ){
        print $_,"   : file\n";
        print "${dir}/$_","   : file\n";
        my $response = $ua->request(POST $url, Content_Type => 'form-data', 
                Content => [
                    'water'  => $probesize,
                    'gradient'  =>  $gradi,
                    'name' => $name,
                    'email' => $email,
                    'Method' => $output,
                    'PDBfile' => ["${dir}/$_"],
                    ],
                    );
        my $html = $response->content;
        open(NEWPDBFILE,">${dir}/$_.txt") or dienice(" Can't open PDB file $!");
        print NEWPDBFILE "$html\n";
        close(NEWPDBFILE);
        sleep(10);
    }elsif(-d $dir . "/" . $_){
        print $_,"   : folder\n";
    }else{
        print $_,"   : other\n";
    }
}
exit;



