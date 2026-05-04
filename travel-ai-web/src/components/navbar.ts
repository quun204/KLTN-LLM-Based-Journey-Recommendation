import { getState, clearAuth } from "../lib/state";
import { navigate } from "../lib/router";

export function renderNavbar(): void {
  const existing = document.querySelector("nav.navbar");
  if (existing) existing.remove();

  const { user } = getState();

  const nav = document.createElement("nav");
  nav.className = "navbar";
  nav.innerHTML = `
    <div class="navbar__inner shell">
      <a class="navbar__brand" href="/" data-link>
        <span class="navbar__logo">✈️</span>
        <span>GoVap Travel</span>
      </a>
      <div class="navbar__links">
        <a href="/about" data-link>Về chúng tôi</a>
        ${user ? '<a href="/itinerary" data-link>Lịch trình của tôi</a>' : ""}
      </div>
      <div class="navbar__auth">
        ${
          user
            ? `<span class="navbar__user">Xin chào, <strong>${user.fullName}</strong></span>
               <button class="btn btn-outline btn-sm" id="logout-btn">Đăng xuất</button>`
            : `<a class="btn btn-outline btn-sm" href="/login" data-link>Đăng nhập</a>
               <a class="btn btn-primary btn-sm" href="/register" data-link>Đăng ký</a>`
        }
      </div>
    </div>
  `;

  document.body.prepend(nav);

  // Handle logout
  nav.querySelector("#logout-btn")?.addEventListener("click", () => {
    clearAuth();
    navigate("/");
    renderNavbar();
  });

  // Handle SPA links
  nav.querySelectorAll<HTMLAnchorElement>("a[data-link]").forEach((a) => {
    a.addEventListener("click", (e) => {
      e.preventDefault();
      navigate(a.getAttribute("href") ?? "/");
    });
  });
}
