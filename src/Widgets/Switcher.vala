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

public class ApplicationsMenu.Widgets.Switcher : Gtk.Grid {
    public signal void on_paginator_changed ();

    private bool has_enough_children {
        get {
            return get_children ().length () > 1;
        }
    }

    private Hdy.Carousel paginator;

    construct {
        halign = Gtk.Align.CENTER;
        orientation = Gtk.Orientation.HORIZONTAL;
        column_spacing = 3;
        can_focus = false;
        show_all ();
    }

    public void set_paginator (Hdy.Carousel paginator) {
        if (this.paginator != null) {
            get_children ().foreach ((child) => {
                child.destroy ();
            });
        }

        this.paginator = paginator;
        foreach (var child in paginator.get_children ()) {
            add_child (child);
        }

        paginator.add.connect_after (add_child);
    }

    private void add_child (Gtk.Widget widget) {
        var button = new PageChecker (paginator, widget);
        add (button);
    }

    public override void show () {
        base.show ();
        if (!has_enough_children) {
            hide ();
        }
    }

    public override void show_all () {
        base.show_all ();
        if (!has_enough_children) {
            hide ();
        }
    }
}
