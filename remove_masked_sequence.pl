#!/usr/bin/env perl 
 
# remove_masked_sequence.pl
# This script will remove completely masked elements from element libraries. 


# Megan Bowman
# 03 February 2014

use strict;
use Getopt::Long;
use Bio::Seq;
use Bio::SeqIO;

my $usage = "\nUsage: $0 --masked_elements <path to LTR.lib to be masked> --outfile <path to final LTR library you create>\n";

my ($masked, $outfile, $seqobj1, $final_count, $seq_length, $n_count, $sub_seq, $sub_count);

GetOptions('masked_elements=s' => \$masked,
	   'outfile=s' => \$outfile);



if (!defined ($masked) ||!defined ($outfile)) {
    die $usage;
}

if (!-e $masked) {
  die "$masked does not exist!\n"
}

if (-e $outfile) {
  die "$outfile already exists!\n"
}

my $repin = Bio::SeqIO->new ( -format => 'fasta', -file => $masked); 
my $seqout = Bio::SeqIO->new (-format => 'fasta', -file => ">$outfile");


while (my $seqobj1 = $repin->next_seq()) {
    my $repseq = $seqobj1->seq();
    $seq_length = length($repseq);
    if ( $seq_length == 0 ) {
        print STDERR "WARNING: zero-length sequence: " + $repseq + "\n";
        continue;
    }
    $sub_seq = $seq_length * .9;
    if ( $sub_seq == 0 ) {
        print STDERR "WARNING: zero-length sub-sequence: " + $repseq + "\n";
        continue;
    }
    $sub_count = 0;
    while ($repseq =~ /([Nn]+)/g) { 
	$n_count += length($1);
	$sub_count = $n_count * .9;
    }
    $final_count = ($sub_count/$sub_seq) * 100;
    if ($final_count >= 80) {
	$n_count = 0;
	next;
    }
    $seqout->write_seq($seqobj1);
    $n_count = 0;
    next;
}

    




