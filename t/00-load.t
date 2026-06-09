use strict;
use warnings;
use Test::More;

# Core (Samizdat) must be on @INC (PERL5LIB) — it provides the Customer plugin
# (required), Samizdat::Model::Cache, and the settings resolver this dist depends on.
use_ok('Samizdat::Model::Invoice');
use_ok('Samizdat::Controller::Invoice');
use_ok('Samizdat::Plugin::Invoice');

# The settings schema ships with the dist and is valid YAML.
use YAML::XS qw(LoadFile);
use File::Spec;
my ($dist_lib) = grep { -d } map { File::Spec->catdir($_, 'Samizdat', 'resources') } @INC;
ok($dist_lib, 'resources dir is on @INC') or diag "no Samizdat/resources under @INC";
my $schema = eval { LoadFile(File::Spec->catfile($dist_lib, 'settings', 'invoice', 'schema.yml')) };
ok(ref $schema eq 'HASH', 'invoice settings schema loads')
  and is($schema->{'x-samizdat-audience'}, 'operator', 'audience is operator');

done_testing;
