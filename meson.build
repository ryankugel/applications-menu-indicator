project(
    'applications-menu-indicator',
    'vala', 'c',
    version: '0.0.1'
)

gnome = import('gnome')

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
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

posix_dep = meson.get_compiler('vala').find_library('posix')

shared_module(
    meson.project_name(),
    config_file,
    'src/ApplicationsMenu.vala',
    'src/Backend/App.vala',
    'src/Backend/AppCenter.vala',
    'src/Backend/AppSystem.vala',
    'src/Backend/Category.vala',
    'src/Backend/DBusService.vala',
    'src/Backend/SwitcherooControl.vala',
    'src/Backend/SynapseSearch.vala',
    'src/synapse-core/Actions/TerminalRunnerAction.vala',
    'src/synapse-core/Actions/RunnerAction.vala',
    'src/synapse-core/Actions/CommonAction.vala',
    'src/synapse-core/Actions/ClipboardCopyAction.vala',
    'src/synapse-core/Actions/BaseAction.vala',
    'src/synapse-core/Interfaces/ItemProvider.vala',
    'src/synapse-core/Interfaces/Configurable.vala',
    'src/synapse-core/Interfaces/Activatable.vala',
    'src/synapse-core/Interfaces/ActionProvider.vala',
    'src/synapse-core/Matches/UriMatch.vala',
    'src/synapse-core/Matches/TextMatch.vala',
    'src/synapse-core/Matches/SearchMatch.vala',
    'src/synapse-core/Matches/Match.vala',
    'src/synapse-core/Matches/DefaultMatch.vala',
    'src/synapse-core/Matches/ApplicationMatch.vala',
    'src/synapse-core/config-service.vala',
    'src/synapse-core/data-sink.vala',
    'src/synapse-core/dbus-service.vala',
    'src/synapse-core/desktop-file-service.vala',
    'src/synapse-core/query.vala',
    'src/synapse-core/relevancy-service.vala',
    'src/synapse-core/result-set.vala',
    'src/synapse-core/utils.vala',
    'src/synapse-plugins/worker-link.vala',
    'src/synapse-plugins/converter-plugin/converter-plugin.vala',
    'src/synapse-plugins/converter-plugin/converter-plugin-backend.vala',
    'src/synapse-plugins/converter-plugin/converter-data.vala',
    'src/synapse-plugins/calculator-plugin/calculator-plugin.vala',
    'src/synapse-plugins/calculator-plugin/calculator-plugin-backend.vala',
    'src/synapse-plugins/command-plugin.vala',
    'src/synapse-plugins/desktop-file-plugin.vala',
    'src/synapse-plugins/file-bookmarks-plugin.vala',
    'src/synapse-plugins/system-managment.vala',
    'src/synapse-plugins/link-plugin.vala',
    'src/synapse-plugins/appcenter-plugin.vala',
    'src/Views/CategoryView.vala',
    'src/Views/GridView.vala',
    'src/Views/MenuView.vala',
    'src/Views/SearchView.vala',
    'src/Widgets/AppButton.vala',
    'src/Widgets/AppContextMenu.vala',
    'src/Widgets/AppListBox.vala',
    'src/Widgets/AppListRow.vala',
    'src/Widgets/PageChecker.vala',
    'src/Widgets/SearchItem.vala',
    'src/Widgets/Switcher.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite', version: '>=6.0.0'),
        dependency('gtk+-3.0'),
        dependency('json-glib-1.0'),
        dependency('libhandy-1', version: '>= 0.83.0'),
        posix_dep,
        swiftpanel_dep
    ],
    install: true,
    install_dir: swiftpanel_indicatorsdir
)

subdir('data')

meson.add_install_script('meson/post_install.py')
