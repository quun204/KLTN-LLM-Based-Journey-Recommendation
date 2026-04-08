import "./styles.css";

import { renderNavbar } from "./components/navbar";
import { route, startRouter } from "./lib/router";
import { loadStoredUser } from "./lib/state";
import { renderHomePage } from "./pages/home";
import { renderLoginPage } from "./pages/login";
import { renderRegisterPage } from "./pages/register";
import { renderNotFoundPage } from "./pages/not-found";
import { renderItineraryPage } from "./pages/itinerary";
import { renderLocationDetailPage } from "./pages/location-detail";
import { renderAboutPage } from "./pages/about";

const app = document.querySelector<HTMLDivElement>("#app");
if (!app) throw new Error("No #app element found.");

// Restore session from localStorage
loadStoredUser();

// Render persistent navbar
renderNavbar();

// Register SPA routes
route("/", () => {
  void renderHomePage(app);
});

route("/login", () => {
  renderLoginPage(app);
});

route("/register", () => {
  renderRegisterPage(app);
});

route("/explore", () => {
  void renderHomePage(app);
});

route("/itinerary", () => {
  void renderItineraryPage(app);
});

route("/about", () => {
  renderAboutPage(app);
});

route("/location/", () => {
  void renderLocationDetailPage(app);
});

route("/404", () => {
  void renderNotFoundPage(app);
});

// Start the router (reads location.pathname and dispatches)
startRouter();
