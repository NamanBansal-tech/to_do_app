class PageMeta {
  final int limit;
  final int offset;
  final bool hasNext;

  PageMeta({
    this.hasNext = true,
    this.limit = 20,
    this.offset = 0,
  });

  PageMeta copyWith({
    int? limit,
    int? offset,
    bool? hasNext,
  }) =>
      PageMeta(
          hasNext: hasNext ?? this.hasNext,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset);
}
