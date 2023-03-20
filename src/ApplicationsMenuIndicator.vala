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

 public class Swiftpanel.ApplicationsMenuIndicator : Swiftpanel.PanelWidget {

    public ApplicationsMenuIndicator () {
        Object (
            code_name: "applications-menu-indicator",
            widget_position: WidgetPosition.LEFT
        );
    }

    /**
     * Returns the widget that is displayed on the panel.
     */
    public override Gtk.Widget get_display_widget () {
        return new Gtk.Label ("Applications");
    }

    /**
     * Returns the widget that is displayed in a popover when the indicator is clicked.
     */
    public override Gtk.Widget? get_content () {
        return new Gtk.Label ("These are your applications!");
    }

    public override void opened () {
    }

    public override void closed () {
    }

 }

 public Swiftpanel.PanelWidget? get_indicator_widget (Swiftpanel.PanelWidget.ServerType server_type) {
     message ("Activating Swiftpanel ApplicationsMenuIndicator");

     if (server_type == Swiftpanel.PanelWidget.ServerType.SESSION) {
         message ("Session ServerType");
         return new Swiftpanel.ApplicationsMenuIndicator ();
     } else {
         message ("Greeter ServerType");
         return null;
     }
 }
