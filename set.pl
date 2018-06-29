#!/usr/bin/perl -l


sub readall {
  my ($fname) = @_;
  open my $handle, '<', $fname;
  chomp(my @lines = <$handle>);
  close $handle;
  return \@lines
}

sub hashify {
  my %E = ();
  $E{$_} = 1 for @_;
  return %E;
}

$usage = sub {
  print "Usage: ";
  print "$0 file1 + file2 # Union of file contents";
  print "$0 file1 - file2 # contents in file1 but not in file2";
  print "$0 file1 = file2 # contents in both file1 and file2";
  return "";
};

$union = sub {
  my ($A, $B) = @_;
  my %E = &hashify(@$A, @$B);
  return sort keys %E;
};

$subtract = sub {
  my ($A, $B) = @_;
  my %E = ();
  my %EA = &hashify (@$A);
  my %EB = &hashify (@$B);
  for (keys %EA) {
    $E{$_} = 1 unless $EB{$_} ;
  }
  return sort keys %E;
};

$intersection = sub {
  my ($A, $B) = @_;
  my @AminusB = $subtract->($A, $B);
  return $subtract->($A, \@AminusB)
};

$A = &readall($ARGV[0]);
$O = $ARGV[1];
$B = &readall(<$ARGV[2]>);

%funcs = ( '+' => $union, '-' => $subtract, '=' => $intersection);
$func = $funcs{$O} || $usage;
@result = $func->($A, $B);
print $_ for @result;
