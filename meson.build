project(
    'applications-menu-indicator',
    'vala', 'c',
    version: '0.0.1'
)

i18n = import('i18n')
gnome = import('gnome')

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')
add_project_arguments('-DG_LOG_DOMAIN="com.github.ryankugel.applications-menu-indicator"', language:'c')

swiftpanel_dep = dependency('swiftpanel')
swiftpanel_indicatorsdir = swiftpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

config_data = configuration_data()
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

shared_module(
    meson.project_name(),
    config_file,
    'src/ApplicationsMenuIndicator.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite', version: '>=6.0.0'),
        dependency('gtk+-3.0'),
        swiftpanel_dep
    ],
    install: true,
    install_dir: swiftpanel_indicatorsdir
)

#subdir('data')

#meson.add_install_script('meson/post_install.py')
