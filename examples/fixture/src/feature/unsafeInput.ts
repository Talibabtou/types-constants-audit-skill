interface SubmitPayload {
  itemId: string;
  amount: number;
}

export const normalizeInput = (input: any): SubmitPayload => {
  const payload = input as unknown as SubmitPayload;

  return {
    itemId: String(payload.itemId),
    amount: Number(payload.amount),
  };
};

export const readOptionalAmount = (value: unknown) => {
  if (typeof value === 'number') {
    return value;
  }

  return 0;
};
