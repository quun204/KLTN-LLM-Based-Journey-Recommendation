import { apiFetchFeaturedItineraryById } from "../lib/api";
import { navigate } from "../lib/router";

type ItineraryItem = Record<string, any>;

function getItemName(item: ItineraryItem): string {
  return item.tên || item.name || item.title || "Địa điểm";
}

function getItemAddress(item: ItineraryItem): string {
  return item.địa_chỉ || item.address || item.địa_chi || "";
}

function getItemImage(item: ItineraryItem): string {
  return item.serpapi_thumbnail
    || item.hình_thu_nhỏ
    || item.imageUrl
    || "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80";
}

function getItemRating(item: ItineraryItem): string {
  const rating = Number(item.xếp_hạng ?? item.rating ?? 0);
  return Number.isFinite(rating) && rating > 0 ? rating.toFixed(1) : "Chưa có";
}

function renderStopCard(item: ItineraryItem, index: number): string {
  const name = getItemName(item);
  const address = getItemAddress(item);
  const image = getItemImage(item);
  const rating = getItemRating(item);
  const phone = item.điện_thoại || item.phone;
  const website = item.trang_web || item.website;
  const opening = item.Gio_mo_cua_hang_ngay || item.openingHours || item.hours || "";
  const category = item.danh_muc || item.categoryName || item.categoryCode || "Điểm dừng";
  const notes = item.mô_tả || item.description || "";
  const time = item.time || item.estimatedTime || `Điểm ${index + 1}`;

  return `
    <article class="itinerary-stop-card">
      <div class="itinerary-stop-card__media">
        <img src="${image}" alt="${name}" loading="lazy" />
        <span class="itinerary-stop-card__time">${time}</span>
      </div>
      <div class="itinerary-stop-card__body">
        <div class="itinerary-stop-card__top">
          <span class="itinerary-stop-card__index">${index + 1}</span>
          <span class="itinerary-stop-card__category">${category}</span>
        </div>
        <h3>${name}</h3>
        <p class="itinerary-stop-card__address">📍 ${address}</p>
        <div class="itinerary-stop-card__meta">
          <span>⭐ ${rating}</span>
          ${opening ? `<span>🕒 ${opening}</span>` : ""}
        </div>
        ${notes ? `<p class="itinerary-stop-card__desc">${notes}</p>` : ""}
        <div class="itinerary-stop-card__actions">
          ${phone ? `<a class="btn btn-outline btn-sm" href="tel:${phone}">📞 Gọi</a>` : ""}
          ${website ? `<a class="btn btn-primary btn-sm" href="${website}" target="_blank" rel="noreferrer">🌐 Website</a>` : ""}
        </div>
      </div>
    </article>
  `;
}

export async function renderItineraryDetailPage(container: HTMLElement): Promise<void> {
  const match = location.pathname.match(/^\/itinerary\/([^/?#]+)/);
  const itineraryId = match ? decodeURIComponent(match[1]) : "";

  if (!itineraryId) {
    navigate("/");
    return;
  }

  container.innerHTML = `
    <section class="section itinerary-detail-page">
      <div class="shell" id="itinerary-detail-root">
        <div class="itinerary-detail-skeleton">
          <p class="section-count">Đang tải lộ trình chi tiết…</p>
        </div>
      </div>
    </section>
  `;

  const root = container.querySelector<HTMLDivElement>("#itinerary-detail-root")!;

  try {
    const itinerary = await apiFetchFeaturedItineraryById(itineraryId);
    const items: ItineraryItem[] = Array.isArray(itinerary.items) ? itinerary.items : [];

    root.innerHTML = `
      <div class="itinerary-detail-hero">
        <button class="btn btn-outline itinerary-detail-back" id="itinerary-detail-back">← Quay lại</button>
        <div class="itinerary-detail-hero__content">
          <div class="itinerary-detail-hero__copy">
            <span class="itinerary-detail-kicker">Lộ trình đề xuất</span>
            <h1>${itinerary.title}</h1>
            <p>${itinerary.description || "Lộ trình 1 ngày được sắp xếp từ dữ liệu MongoDB."}</p>
            <div class="itinerary-detail-tags">
              ${itinerary.tenNguoiDung ? `<span class="badge badge-owner">👤 ${itinerary.tenNguoiDung}</span>` : ""}
              <span class="badge badge-difficulty">${itinerary.difficulty || "Trung bình"}</span>
              <span class="badge badge-for">${itinerary.bestFor || "Tất cả"}</span>
              <span class="badge badge-stops">📍 ${items.length} điểm dừng</span>
              ${itinerary.rating ? `<span class="badge badge-rating">⭐ ${itinerary.rating}/5</span>` : ""}
            </div>
          </div>
          <div class="itinerary-detail-hero__panel">
            <div class="hero-panel-stat">
              <span class="hero-panel-stat__num">${items.length}</span>
              <span class="hero-panel-stat__label">điểm trong lịch trình</span>
            </div>
            <div class="hero-panel-stat">
              <span class="hero-panel-stat__num">${itinerary.totalDuration || "1 ngày"}</span>
              <span class="hero-panel-stat__label">thời lượng dự kiến</span>
            </div>
          </div>
        </div>
      </div>

      <div class="itinerary-detail-grid">
        <div class="itinerary-detail-main">
          <div class="itinerary-detail-section-head">
            <h2>Các điểm dừng trong ngày</h2>
            <p>Sắp xếp theo buổi sáng, trưa, chiều và tối để đi thực tế dễ hơn.</p>
          </div>
          <div class="itinerary-stop-list">
            ${items.map((item, index) => renderStopCard(item, index)).join("")}
          </div>
        </div>

        <aside class="itinerary-detail-side">
          <div class="itinerary-note-card">
            <span class="itinerary-note-card__label">Gợi ý sử dụng</span>
            <h3>Đi theo thứ tự từ trên xuống</h3>
            <p>Trang này lấy dữ liệu trực tiếp từ collection <strong>lichsuyeuthich</strong> trong MongoDB và hiển thị toàn bộ thông tin lộ trình, bao gồm cả tên người dùng tạo lộ trình.</p>
          </div>
          <div class="itinerary-note-card itinerary-note-card--accent">
            <span class="itinerary-note-card__label">Mẹo nhanh</span>
            <h3>Muốn đổi lịch trình?</h3>
            <p>Chỉ cần sửa dữ liệu trong MongoDB là web sẽ tự hiển thị lại ở đây mà không cần build lại nội dung lộ trình.</p>
          </div>
        </aside>
      </div>
    `;

    root.querySelector<HTMLButtonElement>("#itinerary-detail-back")?.addEventListener("click", () => {
      navigate("/");
    });
  } catch {
    root.innerHTML = `
      <div class="empty empty--detail">
        <h2>Không tìm thấy lộ trình này</h2>
        <p>Dữ liệu có thể đã bị xóa hoặc id không hợp lệ.</p>
        <button class="btn btn-primary" id="itinerary-detail-home">Về trang chủ</button>
      </div>
    `;

    root.querySelector<HTMLButtonElement>("#itinerary-detail-home")?.addEventListener("click", () => {
      navigate("/");
    });
  }
}