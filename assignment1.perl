#!/home/account/software/bin/perl

#Assignment Number : #1
#Subject Code and Section : BIF724
#Student Name : Edmund Su
#Student Number : 104699160
#Instructor Name : Danny Abesdris
#Due Date : 02/14/2017
#Date Submitted : 02/10/2017

use strict;
use warnings;

my ($s1,$s2,$match,$misMatch,$gapPenalty,@NWcalculations);

#Nucleotide sequences
$s1 = "ACTGATTCA";
$s2 = "ACGCATCA";

#Splits nucleotide sequences into arrays adds 0 to the front of each array as a filler
my @array1 = split //,$s1;
unshift @array1, "0";
my @array2 = split //,$s2;
unshift @array2, "0";

#Parameters
$match = 1;
$misMatch = -1;
$gapPenalty = -2;

#Prototypes of functions
sub initializeArray($$$);
sub nwArray($$$$$$);
sub max($$$);
sub printFrame($$$);

initializeArray(\@array1,\@array2,\@NWcalculations);
nwArray(\@array1,\@array2,\@NWcalculations,$match,$misMatch,$gapPenalty);
printFrame(\@array1,\@array2,\@NWcalculations);
print "$NWcalculations[length $s2][length $s1]";

#Makes array accordin to size of sequences and fills with zeros
sub initializeArray($$$){
    my $array1 = shift @_;
    my $array2 = shift @_;
    my $NWcalculations = shift @_;
    
    #Tranverses via X per row
    for (my $x=0;$x<scalar(@{$array2});$x++){
    
        #Transverses via Y per entry in row
        #This gets a little confusing. Basically X and Y have switched function for transversing cartesian plane 
        for (my $y=0;$y<scalar(@{$array1});$y++){
                @{$NWcalculations[$x]}[$y]= 0;
            }
    }
}

#Calculates corresponding values via NW 
sub nwArray($$$$$$){
    my $array1 = shift @_;
    my $array2 = shift @_;
    my $NWcalculations = shift @_;
    my $match = shift @_;
    my $misMatch = shift @_;
    my $gapPenalty = shift @_;
 
    #Tranverses via X per row 
     for (my $x=0;$x<scalar(@{$array2});$x++){

        #Transverses via Y per entry in row
        for (my $y=0;$y<scalar(@{$array1});$y++){
        
                #Initializes top left [0][0] to 0
                if ($x==0 && $y==0){
                    @{$NWcalculations[$x]}[$y]= 0;
                }
                
                #If top row i.e. [0][y]; all calculations consist of cumulative gapPenalties using preceeding value left of row entry
                elsif ($x==0 && $y!=0){
                    @{$NWcalculations[$x]}[$y]= @{$NWcalculations[$x]}[$y-1]+$gapPenalty;
                }
                
                #If left most column i.e. [x][0]; calculation is cumulative gapPenalty using preceeding value in upper column entry
                elsif ($x!=0 && $y==0){
                    @{$NWcalculations[$x]}[$y]= @{$NWcalculations[$x-1]}[$y]+$gapPenalty;
                 }
                 
                 #Otherwise follow calculations to determine maximum
                 else{
                 
                    #initialization of variables . Takes value according to rules in assignment
                    my $diagonal;
                    my $horizontal = @{$NWcalculations[$x]}[$y-1] + $gapPenalty;
                    my $vertical = @{$NWcalculations[$x-1]}[$y] + $gapPenalty;
                    
                    #Diagonal value depends on if entry in array comparison match
                    #This gets a little confusing. Basically X and Y have switched function for transversing cartesian plane
                     if (@{$array2}[$x] ne @{$array1}[$y]){
                         $diagonal = @{$NWcalculations[$x-1]}[$y-1] + $misMatch;
                     }
                     else{
                         $diagonal = @{$NWcalculations[$x-1]}[$y-1] + $match;
                     }
                     
                     #Values are placed into array
                    my @tempArray = ($horizontal,$vertical,$diagonal);
                    
                    #Value of current entry is  determied via max function 
                    ${$NWcalculations[$x]}[$y] = max(scalar(@tempArray)-1,$tempArray[0],\@tempArray);
                 }

         }
    }
}    

#Making of frame
sub printFrame($$$){
    my $array1 = shift @_;
    my $array2 = shift @_;
    my $NWcalculations = shift @_;
    
    #Builds body of frame. First has special instance to check for x=0 therefore prints String1/Array1
    #Next starts building string at x consisting of char at String2/Array2 and NW entries at [x] spaced out within frames
    #Follows up by print lower frame filler according to size of previously made string
    for (my $x=0;$x<scalar(@{$array2});$x++){
        
        #A special instance; adds String1 before printing contents ot array
        if ($x==0){
        
            #Filler space for aesthetics
            print " " x 2;
            
            #Prints through each element (i.e. string char) of Array1. Builds into horizontal representation of string 1
            foreach my $element(@{$array1}){
               
               #Accounts for place holder. 0 is replaced with spaces
                if ($element eq "0"){
                    print "    ";
                 }
                else{
                    print "  $element ";
                }
             }
             
             #Moves onto next line and prints top frame according to size of array1
            print "\n";
            print " " x 2;
            foreach my $element(@{$array1}){
                print "+---";
             }
            print "+\n";
        }
        
        #Initializes temporary string (houses the entirety of line to be printed)
        my $string = "";
        
        #Accounts for temporary filler added in array2
        if (${$array2}[$x] eq "0"){
            $string .="  |";
        }
        
        #Appends Array2 element (string letter) specific to position X plus start of frame. Eventually builds to vertical representation of string 2
        else{
        $string .="${$array2}[$x] |";
        }
        
        #Seperate for loop spacing out and print NW values
        for (my $y=0;$y<scalar(@{$array1});$y++){
                my $tempVariable =@{$NWcalculations[$x]}[$y];
                
                #Based on size of NW value between 1-3, appropriate amount of space before and after with frame seperator is added
                if (length($tempVariable)==1){
                    $string .= join (""," ",$tempVariable," |");
                 }
                elsif (length($tempVariable)==2){
                    $string .= join ("",$tempVariable," |");
                 }
                 else {
                    $string .= join ("",$tempVariable,"|");
                 }
            }
            
         #Prints string
         print "$string\n";
         
         #Moves onto next line adding filler space and closing out frame based on size of array1
         print "  ";
         print "+---" x scalar(@{$array1});
         print "+\n";
    }    
} 

#Max subfunction returns biggest number. Compare numbers individually according to initializes temp [] holding vertical,horizontal and diagonal numbers
sub max($$$){
    my $count = shift @_;
    my $max = shift @_;
    my $array = shift @_;
    
    #if reaching end of temporary array return largest value
    if ($count == 0){
        return $max;
     }
     
     #If comparison is bigger than initialized max. A new max is established
     if (@{$array}[$count] > $max){
        $max = @{$array}[$count];
     }
     
     #Allows for transversal of temporary array
     $count--;
     
     #Passes elements via recursion
     return max($count,$max,$array);
}

#Oath:
#
#Student Assignment Submission Form
#==================================
#I/we declare that the attached assignment is wholly my/our
#own work in accordance with Seneca Academic Policy.  No part of this
#assignment has been copied manually or electronically from any
#other source (including web sites) or distributed to other students.
#
#Name(s)                                          Student ID(s)
#Edmund Su                                      104699160
#---------------------------------------------------------------     