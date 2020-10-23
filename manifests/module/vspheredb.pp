# @summary Installs the vsphereDB plugin
#
# @param Enum['absent', 'present'] ensure
#   Ensur es the state of the vspheredb module.
# @param String git_repository
#   The upstream module repository.
# @param Optional[String] git_revision
#   The version of the module that needs to be used.
# @param Enum['mysql', 'pgsql'] db_type
#   The database type. Either mysql or postgres.
# @param String db_host
#   The host where the vspheredb-database will be running
# @param Integer[1,65535] db_port
#   The port on which the database is accessible.
# @param String db_name
#   The name of the database this module should use.
# @param String db_username
#   The username needed to access the database.
# @param String db_password
#   The password needed to access the database.
# @param String db_charset
#   The charset the database is set to.
#
# @example
#   class { 'icingaweb2::module::vspheredb':
#     ensure       => 'present',
#     git_revision => 'v1.1.0',
#     db_host      => 'localhost',
#     db_name      => 'vspheredb',
#     db_username  => 'vspheredb',
#     db_password  => 'supersecret',
#   }
#
class icingaweb2::module::vspheredb (
  String                    $git_repository,
  Enum['absent', 'present'] $ensure       = 'present',
  Optional[String]          $git_revision = undef,
  Enum['mysql', 'pgsql']    $db_type      = 'mysql',
  Optional[Stdlib::Host]    $db_host      = undef,
  Stdlib::Port              $db_port      = 3306,
  Optional[String]          $db_name      = undef,
  Optional[String]          $db_username  = undef,
  Optional[String]          $db_password  = undef,
  String                    $db_charset   = 'utf8mb4',
){
  icingaweb2::config::resource { 'icingaweb2-module-vspheredb':
    type        => 'db',
    db_type     => $db_type,
    host        => $db_host,
    port        => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password,
    db_charset  => $db_charset,
  }

  icingaweb2::module { 'vspheredb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    settings       => {
      'icingaweb2-module-vspheredb' => {
        'section_name' => 'db',
        'target'       => "${::icingaweb2::globals::conf_dir}/modules/vspheredb",
        'settings'     => {
          'resource' => 'icingaweb2-module-vspheredb',
        },
      },
    },
  }
}