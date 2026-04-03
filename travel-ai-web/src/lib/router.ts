type RouteHandler = () => void;

const routes = new Map<string, RouteHandler>();

export function route(path: string, handler: RouteHandler): void {
  routes.set(path, handler);
}

export function navigate(path: string): void {
  history.pushState(null, "", path);
  dispatch(path);
}

function dispatch(path: string): void {
  // Exact match first
  const exact = routes.get(path);
  if (exact) {
    exact();
    return;
  }

  // Prefix match (e.g. "/login" matches "/login?...")
  for (const [key, handler] of routes) {
    if (path.startsWith(key) && key !== "/") {
      handler();
      return;
    }
  }

  // Fallback to "/"
  const fallback = routes.get("/");
  fallback?.();
}

export function startRouter(): void {
  window.addEventListener("popstate", () => dispatch(location.pathname));
  dispatch(location.pathname);
}
