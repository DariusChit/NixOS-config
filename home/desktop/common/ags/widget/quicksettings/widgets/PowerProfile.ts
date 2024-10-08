import { ArrowToggleButton, Menu } from "../ToggleButton";
import icons from "lib/icons";

const pp = await Service.import("powerprofiles");
const profile = pp.bind("active_profile");
const profiles = pp.profiles.map((p) => p.Profile);

const pretty = (str: string) =>
	str
		.split("-")
		.map((str) => `${str.at(0)?.toUpperCase()}${str.slice(1)}`)
		.join(" ");

const PowerProfileToggle = () =>
	ArrowToggleButton({
		name: "ppdctl-profile",
		icon: profile.as((p) => icons.powerprofile[p]),
		label: profile.as(pretty),
		connection: [pp, () => pp.active_profile !== profiles[1]],
		activate: () => (pp.active_profile = profiles[0]),
		deactivate: () => (pp.active_profile = profiles[1]),
		activateOnArrow: false,
	});

const PowerProfileSelector = () =>
	Menu({
		name: "ppdctl-profile",
		icon: profile.as((p) => icons.powerprofile[p]),
		title: "Profile Selector",
		content: [
			Widget.Box({
				vertical: true,
				hexpand: true,
				child: Widget.Box({
					vertical: true,
					children: profiles.map((prof) =>
						Widget.Button({
							on_clicked: () => (pp.active_profile = prof),
							child: Widget.Box({
								children: [
									Widget.Icon(icons.powerprofile[prof]),
									Widget.Label(pretty(prof)),
								],
							}),
						}),
					),
				}),
			}),
		],
	});

export const ProfileToggle = PowerProfileToggle;

export const ProfileSelector = PowerProfileSelector;
