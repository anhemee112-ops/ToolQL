# Tóm tắt từng case của cj_0.b: dòng, các lệnh đọc, hàm được gọi
open F,"<../cfr-dec/nro/cj_0.java"; my $n=0; my ($cur,$line,@ops,@calls);
sub flush { return unless defined $cur; my %s; print "$cur\t$line\t".join(",",map{s/read//r}@ops)."\t".join(" ",@calls)."\n"; }
while(<F>){ $n++; next if $n<1999;
 if(/^\s{20}case (-?\d+):/){ flush(); $cur=$1;$line=$n;@ops=();@calls=(); next}
 if(/^\s{20}default:/){flush();undef $cur;next}
 next unless defined $cur;
 push @ops,$1 while /\.b\(\)\.(read\w+)\(/g;
 push @calls,"$1" while /((?:this|cj_0)\.\w+\(var1_1\))/g;
}
flush();
