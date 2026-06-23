type CreateItemResponse = {
  item: {
    id: string;
    name: string;
    side: 'left' | 'right';
  };
};

export const mockCreateItemResponse: CreateItemResponse = {
  item: {
    id: 'fixture-item',
    name: 'Fixture item',
    side: 'left',
  },
};
