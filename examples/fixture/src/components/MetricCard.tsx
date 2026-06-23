type MetricCardProps = {
  tone: 'blue' | 'green';
  label: string;
};

export function MetricCard({ tone, label }: MetricCardProps) {
  return (
    <article
      className={`rounded-[18px] border border-[#d7dde8] bg-${tone}-600 p-4 px-4 px-4 shadow-[0_18px_60px_rgba(15,23,42,0.16)] transition hover:shadow-[0_18px_60px_rgba(15,23,42,0.16)]`}
    >
      <p className="text-sm font-medium text-white">{label}</p>
    </article>
  );
}
