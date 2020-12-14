#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
$granularity = $ARGV[0];
@startingTimes;
@endingTimes;
@totals;
$clock = 0;
$temp = 0;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
    if ($quantity >= 5) {
      last;
    }

		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$startingTimes[$quantity] = 0;
    $endingTimes[$quantity] = 0;
		$totals[$quantity] = 0;
		$quantity++;
	}
}
close(DATA);

for ($i = 0; $i < $quantity; $i++) {
  open(FH, '>', "out-$i.tr") or die "Can't create out-$i.tr $!";
  open(DATA, "wireless1-out.tr") or die "Can't open $filename $!";
  while (<DATA>) {
    @x = split(/[' ','\[','\]',':']+/);
    if (($x[0] eq 'r') && ($x[3] eq 'AGT') && ($x[6] eq 'tcp')) {
      if (($x[13] eq $send[$i]) && ($x[15] eq $recv[$i])) {
        $temp = $x[1];

        if ($startingTimes[$i] <= 0) {
          $startingTimes[$i] = $temp;
          $clock = $startingTimes[$i];
        }

        if ($temp - $clock < $granularity) {
          $totals[$i] += $x[7] * 8 / 1024;
        } else {
          $endingTimes[$i] = $temp;
          $throughput = $totals[$i] / ($endingTimes[$i] - $clock);
          print FH "$temp $throughput \n";
          $clock += $granularity;
          $totals[$i] = 0;
        }
      }
    }
  }

  if ($temp - $clock < $granularity) {
    $throughput = $totals[$i] / ($temp - $clock);
    print FH "$endingTimes[$i] $throughput \n";
  }
  
  close DATA;
  close FH;
}
