import { Router } from "express";

import { locationService } from "../services/location-service.js";

const locationsRouter = Router();

locationsRouter.get("/", async (request, response) => {
  const limit = Number(request.query.limit ?? 1000);
  const category = typeof request.query.category === "string" ? request.query.category : undefined;
  const search = typeof request.query.search === "string" ? request.query.search : undefined;

  const locations = await locationService.listLocations({
    limit: Number.isFinite(limit) ? Math.min(Math.max(limit, 1), 2000) : 1000,
    category,
    search
  });

  response.json(locations);
});

locationsRouter.get("/:id", async (request, response) => {
  const locationId = Number(request.params.id);

  if (!Number.isFinite(locationId)) {
    response.status(400).json({ message: "Id khong hop le." });
    return;
  }

  const location = await locationService.getLocationById(locationId);

  if (!location) {
    response.status(404).json({ message: "Khong tim thay dia diem." });
    return;
  }

  response.json(location);
});

export { locationsRouter };