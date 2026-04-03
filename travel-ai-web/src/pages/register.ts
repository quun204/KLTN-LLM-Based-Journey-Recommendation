import { apiRegister } from "../lib/api";
import { navigate } from "../lib/router";
import { setAuth } from "../lib/state";
import { renderNavbar } from "../components/navbar";

export function renderRegisterPage(container: HTMLElement): void {
  container.innerHTML = `
    <div class="auth-page">
      <div class="auth-card">
        <div class="auth-card__header">
          <a class="auth-card__brand" href="/" data-link>🗺️ GoVap Travel AI</a>
          <h1>Tạo tài khoản</h1>
          <p>Tham gia cộng đồng khám phá địa điểm Gò Vấp cùng trợ lý AI.</p>
        </div>

        <form class="auth-form" id="register-form" novalidate>
          <div class="form-row-2">
            <div class="form-group">
              <label for="fullName">Họ và tên</label>
              <input id="fullName" name="fullName" type="text" placeholder="Nguyễn Văn A" required />
            </div>
            <div class="form-group">
              <label for="username">Tên đăng nhập</label>
              <input id="username" name="username" type="text" placeholder="nguyenvana" autocomplete="username" required minlength="3" />
            </div>
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input id="email" name="email" type="email" placeholder="you@example.com" autocomplete="email" required />
          </div>
          <div class="form-group">
            <label for="password">Mật khẩu</label>
            <div class="input-eye">
              <input id="password" name="password" type="password" placeholder="Tối thiểu 6 ký tự" autocomplete="new-password" required minlength="6" />
              <button type="button" class="eye-toggle" id="toggle-pw" aria-label="Hiện mật khẩu">👁️</button>
            </div>
            <small class="form-hint">Tối thiểu 6 ký tự</small>
          </div>
          <div class="form-group">
            <label for="confirm">Xác nhận mật khẩu</label>
            <input id="confirm" name="confirm" type="password" placeholder="Nhập lại mật khẩu" autocomplete="new-password" required />
          </div>

          <div class="form-group">
            <label>Danh mục bạn thích (chọn nhiều)</label>
            <div class="pref-grid">
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="khach-san" /> Khách sạn</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="quan-an" /> Quán ăn</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="coffee" /> Cà phê</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="cong-vien" /> Công viên</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="cho" /> Chợ</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="karaoke" /> Karaoke</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="chua" /> Chùa</label>
              <label class="pref-check"><input type="checkbox" name="favoriteCategories" value="nha-tho" /> Nhà thờ</label>
            </div>
          </div>

          <div class="form-group">
            <label for="budgetPerTrip">Ngân sách mỗi chuyến (VND)</label>
            <input id="budgetPerTrip" name="budgetPerTrip" type="number" min="50000" step="50000" placeholder="Ví dụ: 1500000" />
          </div>

          <div class="form-group">
            <label for="foodPreferences">Bạn thích đồ ăn như nào?</label>
            <input id="foodPreferences" name="foodPreferences" type="text" placeholder="Ví dụ: hải sản, lẩu nướng, đồ chay..." />
          </div>

          <div class="form-group">
            <label for="tripStyle">Phong cách du lịch</label>
            <select id="tripStyle" name="tripStyle">
              <option value="">-- Chọn phong cách --</option>
              <option value="gia-dinh">Gia đình</option>
              <option value="cap-doi">Cặp đôi</option>
              <option value="mot-minh">Một mình</option>
              <option value="ban-be">Bạn bè</option>
              <option value="thu-gian">Thư giãn nhẹ nhàng</option>
              <option value="kham-pha">Khám phá nhiều điểm</option>
            </select>
          </div>
          <p class="form-error" id="register-error" hidden></p>
          <button class="btn btn-primary btn-block" type="submit" id="register-btn">Đăng ký</button>
        </form>

        <p class="auth-card__switch">
          Đã có tài khoản?
          <a href="/login" data-link>Đăng nhập</a>
        </p>
      </div>
    </div>
  `;

  // SPA links
  container.querySelectorAll<HTMLAnchorElement>("a[data-link]").forEach((a) => {
    a.addEventListener("click", (e) => {
      e.preventDefault();
      navigate(a.getAttribute("href") ?? "/");
    });
  });

  // Toggle password
  const pwInput = container.querySelector<HTMLInputElement>("#password")!;
  container.querySelector("#toggle-pw")?.addEventListener("click", () => {
    pwInput.type = pwInput.type === "password" ? "text" : "password";
  });

  const form = container.querySelector<HTMLFormElement>("#register-form")!;
  const errorEl = container.querySelector<HTMLParagraphElement>("#register-error")!;
  const btn = container.querySelector<HTMLButtonElement>("#register-btn")!;

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorEl.hidden = true;

    const data = new FormData(form);
    const password = data.get("password") as string;
    const confirm = data.get("confirm") as string;

    if (password !== confirm) {
      errorEl.textContent = "Mật khẩu xác nhận không khớp.";
      errorEl.hidden = false;
      return;
    }

    btn.disabled = true;
    btn.textContent = "Đang xử lý…";

    try {
      const favoriteCategories = form
        .querySelectorAll<HTMLInputElement>('input[name="favoriteCategories"]:checked');

      const result = await apiRegister({
        username: (data.get("username") as string).trim(),
        email: (data.get("email") as string).trim(),
        password,
        fullName: (data.get("fullName") as string).trim(),
        preferences: {
          favoriteCategories: Array.from(favoriteCategories).map((item) => item.value),
          budgetPerTrip: data.get("budgetPerTrip")
            ? Number(data.get("budgetPerTrip"))
            : null,
          foodPreferences: (data.get("foodPreferences") as string).trim(),
          tripStyle: (data.get("tripStyle") as string).trim()
        }
      });
      setAuth(result.user, result.token);
      renderNavbar();
      navigate("/");
    } catch (err) {
      errorEl.textContent =
        err instanceof Error ? err.message : "Đăng ký thất bại.";
      errorEl.hidden = false;
    } finally {
      btn.disabled = false;
      btn.textContent = "Đăng ký";
    }
  });
}
