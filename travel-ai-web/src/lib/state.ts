import type { AuthUser } from "../types";

export interface AppState {
  user: AuthUser | null;
  token: string | null;
}

const FLASH_KEY = "flash_message";
const FAVORITE_KEY = "favorite_location_ids";

const state: AppState = {
  user: null,
  token: localStorage.getItem("token")
};

export function getState(): Readonly<AppState> {
  return state;
}

export function setAuth(user: AuthUser, token: string): void {
  state.user = user;
  state.token = token;
  localStorage.setItem("token", token);
  localStorage.setItem("user", JSON.stringify(user));
}

export function clearAuth(): void {
  state.user = null;
  state.token = null;
  localStorage.removeItem("token");
  localStorage.removeItem("user");
}

export function loadStoredUser(): void {
  const raw = localStorage.getItem("user");
  if (raw) {
    try {
      state.user = JSON.parse(raw) as AuthUser;
    } catch {
      clearAuth();
    }
  }
}

export function setFlashMessage(message: string): void {
  sessionStorage.setItem(FLASH_KEY, message);
}

export function consumeFlashMessage(): string | null {
  const value = sessionStorage.getItem(FLASH_KEY);
  if (value) {
    sessionStorage.removeItem(FLASH_KEY);
  }
  return value;
}

export function getFavoriteLocationIds(): number[] {
  const raw = localStorage.getItem(FAVORITE_KEY);
  if (!raw) {
    return [];
  }

  try {
    const list = JSON.parse(raw) as number[];
    return Array.isArray(list) ? list.filter((id) => Number.isFinite(id)) : [];
  } catch {
    return [];
  }
}

export function toggleFavoriteLocationId(locationId: number): number[] {
  const current = getFavoriteLocationIds();
  const next = current.includes(locationId)
    ? current.filter((id) => id !== locationId)
    : [...current, locationId];

  localStorage.setItem(FAVORITE_KEY, JSON.stringify(next));
  return next;
}
