#!/bin/env perl

use 5.22.0;
use Data::Dumper;
use Date::Calc qw(Delta_DHMS Add_Delta_Days);
use File::Slurp;
use Spreadsheet::XLSX;
my @EPOCH = (1899, 12, 31, 0, 0, 0);

my $file_name = $ARGV[0];
my $excel = Spreadsheet::XLSX->new ($file_name);

foreach my $sheet (@{$excel -> {Worksheet}}) {
    next if($sheet->{Name} !~ /^20/);
    say '--------------------------------------------------------------------------------------------------------------------';
    say $sheet->{Name};

    $sheet -> {MaxRow} ||= $sheet -> {MinRow};
    my @lines;

    foreach my $row ($sheet -> {MinRow} .. $sheet->{MaxRow}) {
        $sheet -> {MaxCol} ||= $sheet->{MinCol};

        my $L;
        my @R;
        foreach my $col ($sheet->{MinCol} ..  $sheet->{MaxCol}) {
            my $cell = $sheet->{Cells} [$row] [$col];
            push @R, $cell->unformatted();
        }
        my @date_time = excel_date2date(shift(@R));
        my $D = sprintf("%d/%d/%d %d:%d:%d",@date_time);
        $L = sprintf("%s\t%s\t%s\t%s\t%s", $D,@R);
        push @lines, $L; 
    }

    my $r;
    my $c;
    for(@lines){
        my $line = $_;
        $line =~ s/\r\n|\r|\n$//;
        my ($datetime, $id, $user, $ip, $sql) = split /\t/, $line ;
        next if($sql =~ /limit/);
        #say $sql;
        my ($date, $time) = split /\s/, $datetime;
        $c++ if($time =~ /^19:/);
        $c++ if($time =~ /^2[0|1|2|3]:/);
        $c++ if($time =~ /^[0|1|2|3|4|5|6|7|8|9]:/);
    }
    say ($c - 1);
}

exit;



#refer to http://search.cpan.org/perldoc?Spreadsheet::WriteExcel::Utility
sub date2excel_date {
    my ($years, $months, $days, $hours, $minutes, $seconds) = @_;

    return undef unless $years;

    $months  ||= 1;
    $days    ||= 1;
    $hours   ||= 0;
    $minutes ||= 0;
    $seconds ||= 0;
    my @date = ($years, $months, $days, $hours, $minutes, $seconds);

    #日時の差分
    ($days, $hours, $minutes, $seconds) = Date::Calc::Delta_DHMS(@EPOCH, @date);

    my $date = $days + ($hours*3600 +$minutes*60 +$seconds)/(24*60*60);

    # Add a day for Excel's missing leap day in 1900  閏年...?
    $date++ if ($date > 59);

    return $date;
}

sub excel_date2date {
    my ($excel_date) = @_;

    $excel_date-- if $excel_date > 60;

    my $date_part = int($excel_date);
    my $time_part = $excel_date - $date_part;
    my @time = excel_time2time($time_part);

    my @date = Date::Calc::Add_Delta_Days(@EPOCH[0..2],$date_part);
    return (@date,@time);
}

sub excel_time2time {
    my ($excel_time) = @_;

    $excel_time = $excel_time*(24*60*60);

    my $hour =		int($excel_time / 3600);
    my $minutes =	int(($excel_time - $hour*3600) / 60);
    my $seconds =	$excel_time % 60;
    return ($hour,$minutes,$seconds);
}
