import { apiGetItinerary, apiRemoveItineraryItem } from "../lib/api";
import { navigate } from "../lib/router";
import { getState, setFlashMessage } from "../lib/state";
import type { LocationItem } from "../types";

function itineraryCard(item: LocationItem): string {
  const img =
    item.imageUrl ??
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80";

  return `
    <article class="loc-card" data-id="${item.id}">
      <div class="loc-card__img">
        <img src="${img}" alt="${item.name}" loading="lazy" />
        <span class="loc-card__cat">${item.categoryName}</span>
      </div>
      <div class="loc-card__body">
        <h3>${item.name}</h3>
        <p class="loc-card__addr">📍 ${item.address}</p>
        <div class="loc-card__foot">
          <button class="badge badge-itinerary badge-itinerary--selected" data-remove-id="${item.id}">Xóa khỏi hành trình</button>
          ${item.priceLabel ? `<span class="badge badge-price">${item.priceLabel}</span>` : ""}
        </div>
      </div>
    </article>
  `;
}

export async function renderItineraryPage(container: HTMLElement): Promise<void> {
  if (!getState().token) {
    setFlashMessage("Vui lòng đăng nhập để xem Hành trình cá nhân.");
    navigate("/");
    return;
  }

  container.innerHTML = `
    <section class="section">
      <div class="shell">
        <div class="section-head">
          <h1 class="section__title">Hành trình cá nhân</h1>
          <span class="section-count" id="itinerary-count">Đang tải…</span>
        </div>
        <div class="locs-grid" id="itinerary-grid"></div>
        <p class="empty" id="itinerary-empty" hidden>Bạn chưa lưu địa điểm nào.</p>
      </div>
    </section>
  `;

  const grid = container.querySelector<HTMLDivElement>("#itinerary-grid")!;
  const empty = container.querySelector<HTMLParagraphElement>("#itinerary-empty")!;
  const count = container.querySelector<HTMLSpanElement>("#itinerary-count")!;

  async function load(): Promise<void> {
    const items = await apiGetItinerary();
    grid.innerHTML = items.map(itineraryCard).join("");
    empty.hidden = items.length > 0;
    count.textContent = `${items.length} địa điểm`;
  }

  try {
    await load();
  } catch {
    count.textContent = "Không thể tải hành trình";
  }

  grid.addEventListener("click", (e) => {
    const removeBtn = (e.target as HTMLElement).closest<HTMLButtonElement>("button[data-remove-id]");
    if (removeBtn) {
      e.stopPropagation();
      const id = Number(removeBtn.dataset.removeId);
      if (!Number.isFinite(id)) {
        return;
      }

      void (async () => {
        await apiRemoveItineraryItem(id);
        await load();
      })();
      return;
    }

    const card = (e.target as HTMLElement).closest<HTMLElement>(".loc-card");
    if (card) {
      navigate(`/location/${card.dataset.id}`);
    }
  });
}
