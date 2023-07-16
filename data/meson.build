install_data(
    'com.github.ryankugel.applications-menu.appdata.xml',
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

install_data(
    'com.github.ryankugel.applications-menu.gschema.xml',
    install_dir: join_paths(datadir, 'glib-2.0', 'schemas')
)

asresources = gnome.compile_resources(
    'as-resources', 'icons.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)
