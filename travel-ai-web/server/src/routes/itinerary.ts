import { Router } from "express";
import { z } from "zod";

import { requireAuth } from "../middleware/auth.js";
import { itineraryService } from "../services/itinerary-service.js";

const itineraryRouter = Router();

const addItemSchema = z.object({
  locationId: z.number().int().positive()
});

itineraryRouter.use(requireAuth);

itineraryRouter.get("/", async (request, response) => {
  const userId = request.user!.id;
  const items = await itineraryService.listLocations(userId);
  response.json({ items });
});

itineraryRouter.post("/items", async (request, response) => {
  const parsed = addItemSchema.safeParse(request.body);
  if (!parsed.success) {
    response.status(400).json({ message: "Du lieu luu hanh trinh khong hop le." });
    return;
  }

  const userId = request.user!.id;
  const items = await itineraryService.addLocation(userId, parsed.data.locationId);
  response.json({ items });
});

itineraryRouter.delete("/items/:locationId", async (request, response) => {
  const locationId = Number(request.params.locationId);
  if (!Number.isFinite(locationId) || locationId <= 0) {
    response.status(400).json({ message: "locationId khong hop le." });
    return;
  }

  const userId = request.user!.id;
  const items = await itineraryService.removeLocation(userId, locationId);
  response.json({ items });
});

export { itineraryRouter };
