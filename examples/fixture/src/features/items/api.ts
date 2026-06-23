type CreateItemRequest = {
  name: string;
  side: 'left' | 'right';
};

type CreateItemResponse = {
  item: {
    id: string;
    name: string;
    side: 'left' | 'right';
  };
};

export async function createItem(payload: CreateItemRequest) {
  const response = await fetch('/api/items', {
    method: 'POST',
    body: JSON.stringify(payload),
  });

  return (await response.json()) as CreateItemResponse;
}
