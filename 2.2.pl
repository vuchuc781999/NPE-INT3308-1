#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
@routingCosts;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$routingCosts[$quantity] = 0;
		$quantity++;
	}
}
close(DATA);

open(DATA, 'wireless1-out.tr') or die "couldn't open file wireless1-out.tr, $!";
while (<DATA>) {
	@x = split(/[' ','\[','\]',':']+/);
	if (($x[0] eq 's') && ($x[3] eq 'MAC') && ($x[6] eq 'AODV') && ($x[26] eq "\(REQUEST\)\n")) {
		$tmpsend = $x[24];
		$tmprecv = $x[22];
		for ($i = 0; $i < $quantity; $i++) {
			if (($tmpsend eq $send[$i]) && ($tmprecv eq $recv[$i])) {
				$routingCosts[$i]++;
			}
		}
	}
}
close(DATA);

$totalCost = 0;
for ($i = 0; $i < $quantity; $i++) {
	$totalCost += $routingCosts[$i];
	print "Routing cost ($send[$i]-$recv[$i] connection): $routingCosts[$i] (packets)\n";
}

$averageCost = $totalCost / $quantity;
print "\nAverage routing cost: $averageCost (packets)\n";
