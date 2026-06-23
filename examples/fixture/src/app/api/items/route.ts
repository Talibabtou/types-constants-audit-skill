import { NextResponse } from 'next/server';

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

export async function POST(request: Request) {
  const payload = (await request.json()) as CreateItemRequest;

  return NextResponse.json({
    item: {
      id: 'fixture-item',
      name: payload.name,
      side: payload.side,
    },
  } satisfies CreateItemResponse);
}
