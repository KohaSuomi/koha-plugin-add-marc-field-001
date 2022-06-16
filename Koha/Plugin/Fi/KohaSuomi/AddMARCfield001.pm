package Koha::Plugin::Fi::KohaSuomi::AddMARCfield001;

use Modern::Perl;
use base qw(Koha::Plugins::Base);
use MARC::Record;

use C4::Biblio qw( ModBiblioMarc );

our $metadata = {
    name            => 'Add MARC field 001',
    author          => 'Pasi Kallinen',
    date_authored   => '2022-06-13',
    date_updated    => "2022-06-15",
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => '0.0.1',
    description     => 'When cataloguing a new biblio record, automatically add field 001 if it is missing, by using the record biblionumber',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);

    return $self;
}

sub install {
    my ( $self, $args ) = @_;

    return 1;
}

sub upgrade {
    my ( $self, $args ) = @_;

    return 1;
}

sub uninstall() {
    my ( $self, $args ) = @_;

    return 1;
}

sub after_biblio_action {
    my ( $self, $args ) = @_;

    return 1 if ($args->{action} ne 'create');

    my $bib = $args->{biblio};
    my $record = eval { $bib->metadata->record };
    my $biblionumber = $args->{biblio_id} || undef;

    return 1 if (!$record || !$biblionumber);

    my $f001 = ($record->field('001')) ? $record->field('001')->data() : undef;
    if (!defined $f001) {
        $record->insert_fields_ordered( MARC::Field->new('001', $biblionumber) );
        ModBiblioMarc($record, $biblionumber);
    }
    return 1;
}

1;
