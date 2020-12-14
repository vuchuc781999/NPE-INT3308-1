#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
@startingTimes;
@totals;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
    if ($quantity >= 5) {
      last;
    }

		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$startingTimes[$quantity] = -1;
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
        if ($startingTimes[$i] == -1) {
          $startingTimes[$i] = $x[1];
        } else {
          $totals[$i] += $x[7];
          if ($x[1] != $startingTimes[$i]) {
            $throughput = $totals[$i] / ($x[1] - $startingTimes[$i]);
            $throughput = $throughput * 8 / 1024;
            print FH "$x[1] $throughput \n";
          }
        }
      }
    }
  }
  close DATA;
  close FH;
}
