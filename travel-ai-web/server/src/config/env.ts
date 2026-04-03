import dotenv from "dotenv";

dotenv.config();

function toBoolean(value: string | undefined, fallback: boolean): boolean {
  if (value === undefined) {
    return fallback;
  }

  return value.trim().toLowerCase() === "true";
}

function toAiProvider(value: string | undefined): "openai" | "gemini" {
  if (!value) {
    return "openai";
  }

  return value.trim().toLowerCase() === "gemini" ? "gemini" : "openai";
}

export const env = {
  port: Number(process.env.PORT ?? 3000),
  useMockData: toBoolean(process.env.USE_MOCK_DATA, true),
  db: {
    server: process.env.DB_SERVER ?? "localhost",
    port: Number(process.env.DB_PORT ?? 1433),
    database: process.env.DB_NAME ?? "DuLichDB1",
    user: process.env.DB_USER ?? "sa",
    password: process.env.DB_PASSWORD ?? "",
    options: {
      encrypt: toBoolean(process.env.DB_ENCRYPT, false),
      trustServerCertificate: toBoolean(process.env.DB_TRUST_SERVER_CERTIFICATE, true)
    }
  },
  aiProvider: toAiProvider(process.env.AI_PROVIDER ?? (process.env.GEMINI_API_KEY ? "gemini" : "openai")),
  aiSystemPrompt:
    process.env.AI_SYSTEM_PROMPT ??
    "Ban la tro ly goi y dia diem du lich cho khu vuc Go Vap. Tra loi bang tieng Viet ngan gon, huu ich, tap trung vao goi y dia diem, ly do phu hop va meo di chuyen.",
  aiTrainRules: process.env.AI_TRAIN_RULES ?? "",
  openAiApiKey: process.env.OPENAI_API_KEY ?? "",
  openAiModel: process.env.OPENAI_MODEL ?? "gpt-4o-mini",
  geminiApiKey: process.env.GEMINI_API_KEY ?? "",
  geminiModel: process.env.GEMINI_MODEL ?? "gemini-1.5-flash",
  jwtSecret: process.env.JWT_SECRET ?? "change_this_secret_in_production",
  jwtExpiresIn: process.env.JWT_EXPIRES_IN ?? "7d"
};