#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
@startingTimes;
@endingTimes;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting'){
		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$quantity++;
	}
}
close(DATA);

open(DATA, 'wireless1-out.tr') or die "couldn't open file wireless1-out.tr, $!";
while (<DATA>) {
	@x = split(/[' ','\[','\]',':']+/);
	if (($x[0] eq 's') && ($x[3] eq 'AGT') && ($x[6] eq 'tcp')) {
		$tmpsend = $x[13];
		$tmprecv = $x[15];
		if ($x[7] == 40) {
			for ($i = 0; $i < $quantity; $i++) {
				if (($tmpsend == $send[$i]) && ($tmprecv == $recv[$i]) && !$startingTimes[$i]) {
					$startingTimes[$i] = $x[1];
					last;
				}
			}
		} elsif ($x[7] > 40) {
			for ($i = 0; $i < $quantity; $i++) {
				if (($tmpsend == $send[$i]) && ($tmprecv == $recv[$i]) && !$endingTimes[$i]) {
					$endingTimes[$i] = $x[1];
					last;
				}
			}
		}
	}
}
close(DATA);

$totalDelay = 0;
for($i = 0; $i < $quantity; $i++){
	$delay = $endingTimes[$i] - $startingTimes[$i];
	$totalDelay += $delay;
	print "Routing delay ($send[$i]-$recv[$i] connection): $delay (s)\n";
}
$averageDelay = $totalDelay / $quantity;
print "\nAverage routing delay: $averageDelay (s)\n";