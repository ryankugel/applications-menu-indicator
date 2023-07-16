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

public class ApplicationsMenu.DBusService : Object {

    [DBus (name = "com.github.ryankugel.ApplicationsMenu.AppLauncherService")]
    private class Service : Object {
        public signal void visibility_changed (bool launcher_visible);
        private Gtk.Widget? view = null;

        public Service (Gtk.Widget view) {
            this.view = view;
            view.show.connect (on_view_visibility_change);
            view.hide.connect (on_view_visibility_change);
        }

        internal void on_view_visibility_change () {
            debug ("Visibility changed. Sending visible = %s over DBus", view.visible.to_string ());
            this.visibility_changed (view.visible);
        }
    }

    private Service? service = null;

    public DBusService (ApplicationsMenu.Views.MenuView view) {
        // Own bus name
        // try to register service name in session bus
        Bus.own_name (BusType.SESSION,
                      "com.github.ryankugel.ApplicationsMenu.AppLauncherService",
                      BusNameOwnerFlags.NONE,
                      (conn) => { on_bus_aquired (conn, view); },
                      name_acquired_handler,
                      () => { critical ("Could not aquire service name"); });

    }

    private void on_bus_aquired (DBusConnection connection, ApplicationsMenu.Views.MenuView view) {
        try {
            // start service and register it as dbus object
            service = new Service (view);
            connection.register_object ("/com/github/ryankugel/ApplicationsMenu/AppLauncherService", service);
        } catch (IOError e) {
            critical ("Could not register service: %s", e.message);
            return_if_reached ();
        }
    }

    private void name_acquired_handler (DBusConnection connection, string name) {
        message ("Service registration suceeded");
        return_if_fail (service != null);
        // Emit initial state
        service.on_view_visibility_change ();
    }
}
