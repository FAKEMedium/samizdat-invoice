use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Find;

# Install EVERYTHING under lib/ — modules AND the resources tree
# (.ep / .yml / .po / .mo / .js / .tex / .md). EUMM's default PM detection only
# picks up .pm/.pod, so we build the PM map ourselves (the Mojolicious-style
# mechanism: ship resources under lib/Samizdat/resources/ so they land in site_perl).
my %pm;
find(
  sub {
    return unless -f;
    return if /\.(bak|orig|rej|swp)$/;
    my $path = $File::Find::name;       # e.g. lib/Samizdat/resources/templates/invoice/index.js
    (my $rel = $path) =~ s{^lib/}{};
    $pm{$path} = "\$(INST_LIB)/$rel";
  },
  'lib',
);

WriteMakefile(
  NAME             => 'Samizdat::Plugin::Invoice',
  VERSION          => '0.01',
  ABSTRACT         => 'Invoicing for Samizdat (create / credit / remind / pay)',
  AUTHOR           => 'Hans Svensson <hans@alipang.se>',
  LICENSE          => 'artistic_2',
  MIN_PERL_VERSION => '5.036',
  PM               => \%pm,
  PREREQ_PM        => {
    'Mojolicious' => '9.0',
    'Hash::Merge' => 0,
    # Samizdat (core) provides the Customer plugin (required), Cache, and the
    # settings resolver; declared as a runtime requirement in META below.
  },
  TEST_REQUIRES => { 'Test::More' => 0 },
  META_MERGE    => {
    'meta-spec' => { version => 2 },
    prereqs     => {
      runtime => {
        # Core ships Customer, which this plugin requires to be loaded.
        requires   => { 'Samizdat' => 0 },
        # Fortnox sync is optional — every call is guarded by helper-detection
        # (helpers->{fortnox} && config{usefortnox}); the plugin runs without it.
        recommends => { 'Samizdat::Plugin::Fortnox' => 0 },
      },
    },
    no_index  => { directory => ['lib/Samizdat/resources'] },
    resources => { license => ['https://dev.perl.org/licenses/artistic.html'] },
  },
  dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
  clean => { FILES => 'Samizdat-Plugin-Invoice-*' },
);
