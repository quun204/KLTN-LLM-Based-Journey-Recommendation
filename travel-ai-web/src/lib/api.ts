import type { ChatMessage, ChatResponse, ItineraryResponse, LocationItem } from "../types";

async function parseResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const payload = (await response.json().catch(() => null)) as {
      message?: string;
    } | null;
    throw new Error(payload?.message ?? "Yêu cầu thất bại.");
  }
  return (await response.json()) as T;
}

function authHeader(): HeadersInit {
  const token = localStorage.getItem("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function fetchLocations(params: {
  category?: string;
  search?: string;
  limit?: number;
}): Promise<LocationItem[]> {
  const query = new URLSearchParams();
  if (params.category) query.set("category", params.category);
  if (params.search) query.set("search", params.search);
  if (params.limit) query.set("limit", String(params.limit));
  return parseResponse<LocationItem[]>(
    await fetch(`/api/locations?${query.toString()}`)
  );
}

export async function fetchLocationById(id: number): Promise<LocationItem> {
  return parseResponse<LocationItem>(
    await fetch(`/api/locations/${id}`)
  );
}

export async function sendChatMessage(
  messages: ChatMessage[]
): Promise<ChatResponse> {
  return parseResponse<ChatResponse>(
    await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json", ...authHeader() },
      body: JSON.stringify({ messages })
    })
  );
}

export async function apiGetItinerary(): Promise<LocationItem[]> {
  const result = await parseResponse<ItineraryResponse>(
    await fetch("/api/itinerary", { headers: authHeader() })
  );
  return result.items;
}

export async function apiAddItineraryItem(locationId: number): Promise<LocationItem[]> {
  const result = await parseResponse<ItineraryResponse>(
    await fetch("/api/itinerary/items", {
      method: "POST",
      headers: { "Content-Type": "application/json", ...authHeader() },
      body: JSON.stringify({ locationId })
    })
  );
  return result.items;
}

export async function apiRemoveItineraryItem(locationId: number): Promise<LocationItem[]> {
  const result = await parseResponse<ItineraryResponse>(
    await fetch(`/api/itinerary/items/${locationId}`, {
      method: "DELETE",
      headers: authHeader()
    })
  );
  return result.items;
}

export interface AuthUser {
  id: number;
  username: string;
  email: string;
  fullName: string;
  role: string;
}

export interface AuthResult {
  user: AuthUser;
  token: string;
}

export async function apiRegister(data: {
  username: string;
  email: string;
  password: string;
  fullName: string;
  preferences?: {
    favoriteCategories?: string[];
    budgetPerTrip?: number | null;
    foodPreferences?: string;
    tripStyle?: string;
  };
}): Promise<AuthResult> {
  return parseResponse<AuthResult>(
    await fetch("/api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
  );
}

export async function apiLogin(data: {
  username: string;
  password: string;
}): Promise<AuthResult> {
  return parseResponse<AuthResult>(
    await fetch("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
  );
}

export async function apiGetMe(): Promise<AuthUser> {
  return parseResponse<AuthUser>(
    await fetch("/api/auth/me", { headers: authHeader() })
  );
}
