#!/bin/perl

use strict;
use warnings;

#########Arena###########

#this program creates an arena to test different competiotion-strategies in a limited resource environment
#the programs are asked if they want to enter the competition and they must return with 'yes' or 'no'
#fighters are randomly chosen from a pool of fighters
#resources and costs can vary
#if no one fights the resources are split equaly
#if only one fights, the fighter gets all resources
#if both fight, the costs are substracted from the resources 
#fight go over several rounds
#the results of each round are printed to a file, which can be read by the 'fighters' to incorporate aditional information, like name of competior or decicions from previous round in thei decision

#the abundance of each competitor is visuilised with a simple R-script and printed to a pdf-file which is updated after each round


#THE RULES
#1st RULE: You do not talk about FIGHT CLUB.

#2nd RULE: You DO NOT talk about FIGHT CLUB.

#...

#3rounds
system ("rm fighter2.txt"); 
open (my $logFile ,'>>', 'Tunier1_logfile.txt') or die "could not open log file\n$!\n";# logfile

my @competitors = (
	('HAWK') x 20,
	('DOVE')x 20 ,
	('RAND')x 20 ,
	#('TIT4TAT')x 5 ,
);

my @fight_summary =(
	'COMPETITOR1', 
	'COMPETITOR2', 
	'Resource',
	'Kosten',
	'Comp1_decision1', 
	'Comp2_decision1',
	'Winner_Round1',
	'Comp1_decision2',
	'Comp2_decision2',
	'Winner_Round2',
	'Comp1_decision3',
	'Comp2_decision3',
	'Winner_Round3',
);
#
my $Resource = 4; #sollte immer größer als 2 sein!!!
my $Kosten = 0;

#initially check how many fighters are present...
countFightR(@competitors);
#####################################
my @newComp = @competitors;

#my $Kaempfe = scalar @competitors * 2;
my $Kaempfe = 20;

for (my $i =1; $i <= $Kaempfe ; $i++){
	my $rand1=int rand(scalar @newComp);
	my $rand2=int rand(scalar @newComp);

	#hier könnte zufällig Resourcenhöhe und Kosten variieren...	

	if ($rand1 == $rand2 ){redo ;}

	my $comp1 = $newComp[$rand1]; #randomly pick competitors...
	my $comp2 = $newComp[$rand2];

	splice (@fight_summary, 0, 4, ($comp1, $comp2, $Resource, $Kosten)); #position the competitors in the fight summary so you know if you are fighter #1 or #2

	print "$comp1\t$comp2\n\@fight_summary:\t@fight_summary\n\n";
#get the decision...
#system ("perl ./$competitors[0].pl @fight_summary");


	print $logFile "fight number $i\n";

	my @winners='';
	
	for (0..2){	#go for 3 rounds...

		my $round=$_+1;
		print "\tRound $round\n";
		my $pos = 4 + $_*3;
		my $Decision_comp1 = `perl ./$comp1.pl @fight_summary`; #get the decision if competitors want to fight or not
		chomp $Decision_comp1;
		my $Decision_comp2 = `perl ./$comp2.pl @fight_summary`;
		chomp $Decision_comp2;
		

		my @winner = fight4($comp1,$Decision_comp1,$comp2, $Decision_comp2,$Resource,$Kosten);
		#if($Decision_comp1 =~ m/ja/i || $Decision_comp1 =~ m/nein/i) {print "$Decision_comp1\t$Decision_comp2\tinput ist nicht ja oder nein\n\n"; exit;}
	
		splice (@fight_summary, $pos, 3, ($Decision_comp1,$Decision_comp2,join ('_and_', @winner))); #2 5 8 save in summary...
		print join("\t",@fight_summary),"\n";
		if ($winner[0] =~ m/Kein_Gewinner_Kosten_zu_hoch!/ ){next;}
		else {push (@newComp, @winner);}
		

	}
print $$logFile join("\t",@fight_summary),"\n";

@fight_summary =(
	'COMPETITOR1', 
	'COMPETITOR2', 
	'Comp1_decision1', 
	'Comp2_decision1',
	'Winner_Round1',
	'Comp1_decision2',
	'Comp2_decision2',
	'Winner_Round2',
	'Comp1_decision3',
	'Comp2_decision3',
	'Winner_Round3',
);
countFightR(@newComp);
sleep 1;
}


##################################

sub fight4{

my ($comp1,$Kampf1,$comp2, $Kampf2,$Resource,$Kosten) =@_;
	if($Kampf1 eq 'yes' && $Kampf2 eq 'yes'){	#wenn beide kämpfen
	#was passiert, wenn keiner gewinnt..?
	my $fightFaktor = int(($Resource - $Kosten) / 2);
		if ($fightFaktor > 0 ){ 		#nur wenn noch was übrig bleibt...
			return (($comp1) x $fightFaktor ,($comp2) x $fightFaktor);
		}
		else{
		return 'Kein_Gewinner_Kosten_zu_hoch!';
		}	
	}
	elsif($Kampf1 eq 'no' && $Kampf2 eq 'no'){
		
		my $faktor= int ($Resource /2); #ganzzahlig!
		return ($comp1) x $faktor ,($comp2) x $faktor;
			
	}
	else{
	if($Kampf1 eq 'yes'){return ($comp1) x $Resource ;}
	else{return ($comp2) x $Resource;}
		
	}


}
sub countFightR{
my @array=@_;
my %counts;
for my $fightR (@array){
$counts{$fightR}++;
}
open (my $fh ,'>', 'fighter.txt') or die "could not open output file $!\n";
for my $key (sort keys %counts){
	print $fh "$key $counts{$key}\n";
}
close $fh;

open (my $fh2 ,'>>', 'fighter2.txt') or die "could not open output file $!\n";
for my $key2 (sort keys %counts){
	print $fh2 "$counts{$key2} ";
}
print $fh2 "\n";

close $fh2;
system ("Rscript fighter_count.R");
}
