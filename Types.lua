local Types = {}

export type Array<V = any> = { [number]: V }
export type Dictionary<V = any> = { [string]: V }
export type Mapping<K = any, V = any> = { [K]: V }
export type Table = Mapping<any, any>
export type Tuple<T = any> = (T)

return Types
