/*
 * Copyright (c) 2023 Ryan Kugel <ryanrkugel@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

#if HAS_PLANK
[CCode (cname = "PKGDATADIR")]
private extern const string PKGDATADIR;
#endif

 public class ApplicationsMenu.Indicator : Swiftpanel.PanelWidget {
    private const string KEYBINDING_SCHEMA = "org.pantheon.desktop.gala.keybindings";
    private const string GALA_BEHAVIOR_SCHEMA = "org.pantheon.desktop.gala.behavior";

    private DBusService? dbus_service = null;
    private Gtk.Grid? indicator_grid = null;
    private Views.MenuView? view = null;

    private static GLib.Settings? keybinding_settings;
    private static GLib.Settings? gala_behavior_settings;

    public Indicator () {
        Object (
            code_name: "applications-menu-indicator",
            widget_position: WidgetPosition.LEFT
        );
    }

    static construct {
        if (SettingsSchemaSource.get_default ().lookup (KEYBINDING_SCHEMA, true) != null) {
            keybinding_settings = new GLib.Settings (KEYBINDING_SCHEMA);
        }

        if (SettingsSchemaSource.get_default ().lookup (GALA_BEHAVIOR_SCHEMA, true) != null) {
            gala_behavior_settings = new GLib.Settings (GALA_BEHAVIOR_SCHEMA);
        }
    }

    construct {
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/ryankugel/applications-menu/icons"); // TODO
    }

    /**
     * Returns the widget that is displayed on the panel.
     */
    public override Gtk.Widget get_display_widget () {
        if (indicator_grid == null) {
            // TODO: Replace label and icon with elementary logo only
            var indicator_label = new Gtk.Label ("Applications");
            indicator_label.vexpand = true;

            var indicator_icon = new Gtk.Image.from_icon_name ("system-search-symbolic", Gtk.IconSize.MENU);

            indicator_grid = new Gtk.Grid ();
            indicator_grid.attach (indicator_icon, 0, 0, 1, 1);
            indicator_grid.attach (indicator_label, 1, 0, 1, 1);
            update_tooltip ();

            if (keybinding_settings != null) {
                keybinding_settings.changed.connect ((key) => {
                    if (key == "panel-main-menu") {
                        update_tooltip ();
                    }
                });
            }

            if (gala_behavior_settings != null) {
                gala_behavior_settings.changed.connect ((key) => {
                    if (key == "overlay-action") {
                        update_tooltip ();
                    }
                });
            }
        }

        return indicator_grid;
    }

    /**
     * Returns the widget that is displayed in a popover when the indicator is clicked.
     */
    public override Gtk.Widget? get_content () {
        if (view == null) {
            view = new Views.MenuView ();

#if HAS_PLANK
            unowned Plank.Unity client = Plank.Unity.get_default ();
            client.add_client (view);
#endif

            view.close_indicator.connect (on_close_indicator);

            if (dbus_service == null) {
                dbus_service = new DBusService (view);
            }
        }

        return view;
    }

    private void on_close_indicator () {
        close ();
    }

    public override void opened () {
        if (view != null) {
            view.show_menu ();
        }
    }

    public override void closed () {
    }

    private void update_tooltip () {
        string[] accels = {};

        if (keybinding_settings != null && indicator_grid != null) {
            var raw_accels = keybinding_settings.get_strv ("panel-main-menu");
            foreach (unowned string raw_accel in raw_accels) {
                if (raw_accel != "") accels += raw_accel;
            }
        }

        if (gala_behavior_settings != null) {
            if ("swiftpanel" in gala_behavior_settings.get_string ("overlay-action")) {
                accels += "<Super>";
            }
        }

        indicator_grid.tooltip_markup = Granite.markup_accel_tooltip (accels, _("Open and search apps"));
    }
 }

 public Swiftpanel.PanelWidget? get_indicator_widget (Swiftpanel.PanelWidget.ServerType server_type) {
     message ("Activating Swiftpanel ApplicationsMenu indicator");

     if (server_type == Swiftpanel.PanelWidget.ServerType.SESSION) {
         message ("Session ServerType");
         return new ApplicationsMenu.Indicator ();
     } else {
         message ("Greeter ServerType");
         return null;
     }
 }
